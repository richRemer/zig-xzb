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

    const atoms = AppAtoms.init(conn, true);

    std.debug.print("\n", .{});
    std.debug.print("{}\n", .{atoms});
}

fn Intern(T: type) type {
    const field_names = std.meta.fieldNames(T);
    const len = field_names.len;

    return struct {
        conn: *xzb.connection_t,
        cookies: [len]xzb.intern_atom_cookie_t,

        pub fn begin(conn: *xzb.connection_t, exists: bool) @This() {
            var this: @This() = .{ .conn = conn, .cookies = undefined };

            inline for (field_names, 0..) |field_name, i| {
                this.cookies[i] = xzb.intern_atom(conn, exists, field_name);
            }

            return this;
        }

        pub fn finalize(this: @This()) T {
            var atoms: T = undefined;

            inline for (field_names, 0..) |field_name, i| {
                const cookie = this.cookies[i];
                const reply = xzb.intern_atom_reply(this.conn, cookie);
                @field(atoms, field_name) = if (reply) |r| r.atom else 0;
            }

            return atoms;
        }
    };
}

const AppAtoms = struct {
    WM_DELETE_WINDOW: xzb.atom_t,
    WM_PROTOCOLS: xzb.atom_t,
    WM_STATE: xzb.atom_t,

    pub fn init(conn: *xzb.connection_t, exists: bool) AppAtoms {
        return Intern(AppAtoms).begin(conn, exists).finalize();
    }
};
