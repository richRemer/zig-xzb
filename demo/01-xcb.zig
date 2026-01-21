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
            const window = create_window(conn, screen);
            const gc = create_gc(conn, screen);

            _ = xcb.xcb_map_window(conn, window);
            _ = xcb.xcb_flush(conn);

            loop: while (xcb.xcb_wait_for_event(conn)) |e| {
                const evt: *xcb.xcb_generic_event_t = @ptrCast(e);

                // TODO: use u7 field to explicit skip bit twiddling op
                // TODO: MSB indicates SendEvent from another X client
                switch (evt.response_type & ~@as(u8, 0x80)) {
                    xcb.XCB_EXPOSE => {
                        std.debug.print("EXPOSE\n", .{});
                        _ = xcb.xcb_poly_fill_rectangle(conn, window, gc, 1, rects.ptr);
                        _ = xcb.xcb_flush(conn);
                    },
                    xcb.XCB_KEY_PRESS => {
                        const event: *xcb.xcb_key_press_event_t = @ptrCast(evt);
                        std.debug.print("KEY_PRESS {d}\n", .{event.detail});
                        if (event.detail == 9) { // ESCAPE
                            std.c.free(e);
                            break :loop;
                        }
                    },
                    else => {
                        std.debug.print("??? {d}\n", .{evt.response_type});
                    },
                }

                std.c.free(e);
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

    return window;
}
