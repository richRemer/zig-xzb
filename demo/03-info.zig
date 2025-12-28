const std = @import("std");
const xzb = @import("xzb");

pub fn main() void {
    var screen_num: c_int = undefined;
    var roots: xzb.screen_iterator_t = undefined;

    const conn = xzb.connect(null, &screen_num);
    const setup = xzb.get_setup(conn);

    std.debug.print("Connected to X server on screen #{d}\n", .{screen_num});
    std.debug.print("Gathering info on attached screens:\n", .{});
    roots = xzb.setup_roots_iterator(setup);

    while (roots.rem > 0) {
        const screen: *xzb.screen_t = @ptrCast(roots.data);

        std.debug.print("\n", .{});

        std.debug.print("Screen (id: {d}):\n", .{screen.root});
        std.debug.print("  width  : {d}px\n", .{screen.width_in_pixels});
        std.debug.print("  height : {d}px\n", .{screen.height_in_pixels});
        std.debug.print("  depth  : {d}bit\n", .{screen.root_depth});
        std.debug.print("  black  : {x}\n", .{screen.black_pixel});
        std.debug.print("  white  : {x}\n", .{screen.white_pixel});

        xzb.screen_next(&roots);
    }
}
