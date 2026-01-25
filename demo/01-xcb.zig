const std = @import("std");
const xcb = @cImport(@cInclude("xcb/xcb.h"));
const rectangle = xcb.xcb_rectangle_t;

var rect: rectangle = .{ .x = 20, .y = 20, .width = 60, .height = 60 };

pub fn main() void {
    if (xcb.xcb_connect(null, null)) |conn| {
        const setup = xcb.xcb_get_setup(conn);
        const roots = xcb.xcb_setup_roots_iterator(setup);
        const rects: []const rectangle = @as(*[1]rectangle, @ptrCast(&rect));

        if (roots.data) |data| {
            const screen: *xcb.xcb_screen_t = @ptrCast(data);
            const atoms = AppAtoms.init(conn);
            const window = create_window(conn, screen, &atoms);
            const gc = create_gc(conn, screen);

            _ = xcb.xcb_map_window(conn, window);
            _ = xcb.xcb_flush(conn);

            loop: while (xcb.xcb_wait_for_event(conn)) |e| {
                defer std.c.free(e);
                const evt: *xcb.xcb_generic_event_t = @ptrCast(e);

                // TODO: use u7 field to explicit skip bit twiddling op
                // TODO: MSB indicates SendEvent from another X client
                switch (evt.response_type & ~@as(u8, 0x80)) {
                    xcb.XCB_EXPOSE => {
                        _ = xcb.xcb_poly_fill_rectangle(conn, window, gc, 1, rects.ptr);
                        _ = xcb.xcb_flush(conn);
                    },
                    xcb.XCB_KEY_PRESS => {
                        const event: *xcb.xcb_key_press_event_t = @ptrCast(evt);
                        if (event.state == 4 and event.detail == 25) break :loop;
                    },
                    xcb.XCB_CLIENT_MESSAGE => {
                        const event: *xcb.xcb_client_message_event_t = @ptrCast(evt);
                        const atom = event.data.data32[0];
                        if (atom == atoms.WM_DELETE_WINDOW) break :loop;
                    },
                    else => {
                        std.debug.print("??? {d}\n", .{evt.response_type});
                    },
                }
            }

            _ = xcb.xcb_free_gc(conn, gc);
            _ = xcb.xcb_destroy_window(conn, window);
            _ = xcb.xcb_disconnect(conn);

            std.process.exit(0);
        }
    }
}

fn create_gc(
    conn: *xcb.xcb_connection_t,
    screen: *const xcb.xcb_screen_t,
) xcb.xcb_gcontext_t {
    const gc = xcb.xcb_generate_id(conn);
    const values: [3]u32 = .{ screen.white_pixel, screen.black_pixel, 0 };
    const mask: u32 =
        xcb.XCB_GC_BACKGROUND |
        xcb.XCB_GC_FOREGROUND |
        xcb.XCB_GC_GRAPHICS_EXPOSURES;

    _ = xcb.xcb_create_gc(conn, gc, screen.root, mask, &values);

    return gc;
}

fn create_window(
    conn: *xcb.xcb_connection_t,
    screen: *xcb.xcb_screen_t,
    atoms: *const AppAtoms,
) xcb.xcb_window_t {
    const window = xcb.xcb_generate_id(conn);
    const emask: u32 =
        xcb.XCB_EVENT_MASK_EXPOSURE |
        xcb.XCB_EVENT_MASK_KEY_PRESS;
    const values: [2]u32 = .{ screen.black_pixel, emask };
    const mask: u32 =
        xcb.XCB_CW_BACK_PIXEL |
        xcb.XCB_CW_EVENT_MASK;

    _ = xcb.xcb_create_window(
        conn,
        screen.root_depth,
        window,
        screen.root,
        0,
        0,
        100,
        100,
        0,
        xcb.XCB_COPY_FROM_PARENT,
        xcb.XCB_COPY_FROM_PARENT,
        mask,
        &values,
    );

    _ = xcb.xcb_change_property(
        conn,
        xcb.XCB_PROP_MODE_REPLACE,
        window,
        xcb.XCB_ATOM_WM_NAME,
        xcb.XCB_ATOM_STRING,
        8,
        "hello?".len,
        "hello?",
    );

    _ = xcb.xcb_change_property(
        conn,
        xcb.XCB_PROP_MODE_REPLACE,
        window,
        atoms.WM_PROTOCOLS,
        xcb.XCB_ATOM_ATOM,
        32,
        1,
        &atoms.WM_DELETE_WINDOW,
    );

    return window;
}

const AppAtoms = struct {
    WM_DELETE_WINDOW: xcb.xcb_atom_t,
    WM_PROTOCOLS: xcb.xcb_atom_t,

    pub fn init(conn: *xcb.xcb_connection_t) AppAtoms {
        const field_names = comptime std.meta.fieldNames(AppAtoms);
        const len = field_names.len;

        var cookies: [len]xcb.xcb_intern_atom_cookie_t = undefined;
        var atoms: AppAtoms = undefined;

        inline for (field_names, 0..) |name, i| {
            cookies[i] = xcb.xcb_intern_atom(
                conn,
                1,
                @intCast(name.len),
                @ptrCast(name.ptr),
            );
        }

        inline for (field_names, 0..) |name, i| {
            if (xcb.xcb_intern_atom_reply(conn, cookies[i], null)) |reply| {
                @field(atoms, name) = reply.*.atom;
                std.c.free(reply);
            } else {
                @field(atoms, name) = 0;
            }
        }

        return atoms;
    }
};
