const std = @import("std");
const xzb = @import("xzb");
const copy = xzb.xcb.XCB_COPY_FROM_PARENT;

pub fn main() void {
    const conn = xzb.connect(null, null);
    const setup = xzb.get_setup(conn);
    const roots = xzb.setup_roots_iterator(setup);

    if (roots.data) |data| {
        const screen: *xzb.screen_t = @ptrCast(data);
        const atoms = AppAtoms.init(conn);
        const window = create_window(conn, screen, &atoms);
        const gc = create_gc(conn, screen);

        _ = xzb.map_window(conn, window);
        _ = xzb.flush(conn);

        loop: while (xzb.wait_for_event(conn)) |e| {
            defer std.c.free(e);

            // TODO: use u7 field to explicit skip bit twiddling op
            // TODO: MSB indicates SendEvent from another X client
            switch (e.response_type & ~@as(u8, 0x80)) {
                xzb.xcb.XCB_EXPOSE => {
                    _ = xzb.image_text_8(conn, window, gc, 5, 50, "zigga what?");
                    _ = xzb.flush(conn);
                },
                xzb.xcb.XCB_KEY_PRESS => {
                    const event: *xzb.key_press_event_t = @ptrCast(e);
                    if (event.state == 4 and event.detail == 25) break :loop;
                },
                xzb.xcb.XCB_CLIENT_MESSAGE => {
                    const event: *xzb.client_message_event_t = @ptrCast(e);
                    const atom = event.data.data32[0];
                    if (atom == atoms.WM_DELETE_WINDOW) break :loop;
                },
                else => {
                    std.debug.print("??? {d}\n", .{e.response_type});
                },
            }
        }

        _ = xzb.free_gc(conn, gc);
        _ = xzb.destroy_window(conn, window);
        _ = xzb.disconnect(conn);

        std.process.exit(0);
    }
}

fn create_gc(
    conn: *xzb.connection_t,
    screen: *const xzb.screen_t,
) xzb.gcontext_t {
    const gc = xzb.generate_id(conn);
    const font = xzb.generate_id(conn);

    // SHOULD keep these in CreateGCMask order
    const mask = xzb.CreateGCMask{
        .background = true,
        .foreground = true,
        .font = true,
        .graphics_exposures = true,
    };

    // MUST keep these in CreateGCMask order
    const values: [4]u32 = .{
        screen.white_pixel,
        screen.black_pixel,
        font,
        0,
    };

    _ = xzb.open_font(conn, font, "*nimbus sans*regular*r-normal*8859-1");
    _ = xzb.create_gc(conn, gc, screen.root, mask, &values);
    _ = xzb.close_font(conn, font);

    return gc;
}

fn create_window(
    conn: *xzb.connection_t,
    screen: *xzb.screen_t,
    atoms: *const AppAtoms,
) xzb.window_t {
    const window = xzb.generate_id(conn);
    const events: xzb.EventMask = .{ .exposure = true, .key_press = true };
    const values: [2]u32 = .{ screen.black_pixel, @bitCast(events) };
    const protocols: [1]u32 = .{atoms.WM_DELETE_WINDOW};
    const mask = xzb.CreateWindowMask{
        .back_pixel = true,
        .event_mask = true,
    };

    _ = xzb.create_window(
        conn,
        screen.root_depth,
        window,
        screen.root,
        0,
        0,
        100,
        100,
        0,
        copy,
        copy,
        mask,
        &values,
    );

    _ = xzb.change_property(
        conn,
        .replace,
        window,
        xzb.xatom.property.wm_name,
        xzb.xatom.type.string,
        u8,
        "hello?",
    );

    _ = xzb.change_property(
        conn,
        .replace,
        window,
        atoms.WM_PROTOCOLS,
        xzb.xatom.type.atom,
        xzb.atom_t,
        &protocols,
    );

    return window;
}

const AppAtoms = struct {
    WM_DELETE_WINDOW: xzb.atom_t,
    WM_PROTOCOLS: xzb.atom_t,

    pub fn init(conn: *xzb.connection_t) AppAtoms {
        const field_names = comptime std.meta.fieldNames(AppAtoms);
        const len = field_names.len;

        var cookies: [len]xzb.intern_atom_cookie_t = undefined;
        var atoms: AppAtoms = undefined;

        inline for (field_names, 0..) |name, i| {
            cookies[i] = xzb.intern_atom(conn, true, name);
        }

        inline for (field_names, 0..) |name, i| {
            if (xzb.intern_atom_reply(conn, cookies[i])) |reply| {
                @field(atoms, name) = reply.atom;
                std.c.free(reply);
            } else {
                @field(atoms, name) = 0;
            }
        }

        return atoms;
    }
};
