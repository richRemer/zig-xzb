const std = @import("std");
const xzb = @import("xzb");

const copy = xzb.xcb.XCB_COPY_FROM_PARENT;

pub fn main() void {
    const conn = xzb.connect(null, null);
    const setup = xzb.get_setup(conn);
    const roots = xzb.setup_roots_iterator(setup);
    const window = xzb.generate_id(conn);
    const gc = xzb.generate_id(conn);
    const rects: []const xzb.rectangle_t = &.{
        .{ .x = 10, .y = 10, .width = 80, .height = 80 },
    };

    if (roots.data) |data| {
        const screen: *xzb.screen_t = @ptrCast(data);
        const gcmask = xzb.GCMask{ .background = true, .foreground = true };
        const gcvals: [2]u32 = .{ screen.white_pixel, screen.black_pixel };

        _ = xzb.create_gc(conn, gc, screen.root, gcmask, &gcvals);

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

        std.Thread.sleep(100_000_000 * 5);

        _ = xzb.poly_fill_rectangle(conn, window, gc, rects);
        _ = xzb.flush(conn);

        std.Thread.sleep(1_000_000_000 * 5);

        _ = xzb.destroy_window(conn, window);
        _ = xzb.disconnect(conn);

        std.process.exit(0);
    }
}
