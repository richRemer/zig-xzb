const std = @import("std");
const xcb = @cImport(@cInclude("xcb/xcb.h"));

pub fn main() void {
    if (xcb.xcb_connect(null, null)) |conn| {
        const setup = xcb.xcb_get_setup(conn);
        const roots = xcb.xcb_setup_roots_iterator(setup);
        const window = xcb.xcb_generate_id(conn);
        const gc = xcb.xcb_generate_id(conn);
        const rects: []const xcb.xcb_rectangle_t = &.{
            .{ .x = 10, .y = 10, .width = 80, .height = 80 },
        };

        if (roots.data) |data| {
            const screen: *xcb.xcb_screen_t = @ptrCast(data);
            const gcmask: u32 = xcb.XCB_GC_BACKGROUND | xcb.XCB_GC_FOREGROUND;
            const gcvals: [2]u32 = .{ screen.white_pixel, screen.black_pixel };

            _ = xcb.xcb_create_gc(conn, gc, screen.root, gcmask, &gcvals);

            _ = xcb.xcb_create_window(
                conn,
                screen.root_depth,
                window,
                screen.root,
                100,
                100,
                100,
                100,
                0,
                xcb.XCB_COPY_FROM_PARENT,
                xcb.XCB_COPY_FROM_PARENT,
                0,
                null,
            );

            _ = xcb.xcb_map_window(conn, window);
            _ = xcb.xcb_flush(conn);

            std.Thread.sleep(100_000_000 * 5);

            _ = xcb.xcb_poly_fill_rectangle(conn, window, gc, 1, rects.ptr);
            _ = xcb.xcb_flush(conn);

            std.Thread.sleep(5_000_000_000);

            _ = xcb.xcb_destroy_window(conn, window);
            _ = xcb.xcb_disconnect(conn);

            std.process.exit(0);
        }
    }
}
