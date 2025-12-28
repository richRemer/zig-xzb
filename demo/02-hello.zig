const std = @import("std");
const xzb = @import("xzb");

const copy = xzb.xcb.XCB_COPY_FROM_PARENT;

pub fn main() void {
    const conn = xzb.connect(null, null);
    const setup = xzb.get_setup(conn);
    const roots = xzb.setup_roots_iterator(setup);
    const window = xzb.generate_id(conn);

    if (roots.data) |data| {
        const screen: *xzb.screen_t = @ptrCast(data);

        _ = xzb.create_window(
            conn,
            screen.root_depth,
            window,
            screen.root,
            100,
            100,
            100,
            100,
            0,
            copy,
            copy,
            0,
            null,
        );

        _ = xzb.map_window(conn, window);
        _ = xzb.flush(conn);

        std.Thread.sleep(1_000_000_000 * 5);
        std.process.exit(0);
    }
}
