const std = @import("std");
const xcb = @cImport(@cInclude("xcb/xcb.h"));

pub fn main() void {
    if (xcb.xcb_connect(null, null)) |conn| {
        const setup = xcb.xcb_get_setup(conn);
        const roots = xcb.xcb_setup_roots_iterator(setup);
        const window = xcb.xcb_generate_id(conn);

        if (roots.data) |data| {
            const screen: *xcb.xcb_screen_t = @ptrCast(data);

            const create_cookie = xcb.xcb_create_window(
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
            _ = create_cookie;

            const map_cookie = xcb.xcb_map_window(conn, window);
            _ = map_cookie;

            _ = xcb.xcb_flush(conn);

            std.Thread.sleep(5_000_000_000);
            std.process.exit(0);
        }
    }
}
