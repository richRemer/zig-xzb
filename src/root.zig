const std = @import("std");

// TODO: make this non-pub once sufficiently ported
pub const xcb = @cImport(@cInclude("xcb/xcb.h"));

pub const Result = enum(c_int) {
    ok = 0,
    _,
};

pub const ErrorCode = enum(u8) {
    request = 1,
    value = 2,
    window = 3,
    pixmap = 4,
    atom = 5,
    cursor = 6,
    font = 7,
    match = 8,
    drawable = 9,
    access = 10,
    alloc = 11,
    colormap = 12,
    g_context = 13,
    id_choice = 14,
    name = 15,
    length = 16,
    implementation = 17,
};

pub const Error = extern union {
    request: request_error_t,
    value: value_error_t,
    window: value_error_t,
    pixmap: value_error_t,
    atom: value_error_t,
    cursor: value_error_t,
    font: value_error_t,
    match: request_error_t,
    drawable: value_error_t,
    access: request_error_t,
    alloc: request_error_t,
    colormap: value_error_t,
    g_context: value_error_t,
    id_choice: value_error_t,
    name: request_error_t,
    length: request_error_t,
    implementation: request_error_t,
};

pub const OpCode = enum(u8) {
    create_window = 1,
    change_window_attributes = 2,
    get_window_attributes = 3,
    destroy_window = 4,
    destroy_subwindows = 5,
    change_save_set = 6,
    reparent_window = 7,
    map_window = 8,
    map_subwindows = 9,
    unmap_window = 10,
    unmap_subwindows = 11,
    configure_window = 12,
    circulate_window = 13,
    get_geometry = 14,
    query_tree = 15,
    intern_atom = 16,
    get_atom_name = 17,
    change_property = 18,
    delete_property = 19,
    get_property = 20,
    list_properties = 21,
    set_selection_owner = 22,
    get_selection_owner = 23,
    convert_selection = 24,
    send_event = 25,
    grab_pointer = 26,
    ungrab_pointer = 27,
    grab_button = 28,
    ungrab_button = 29,
    change_active_pointer_grab = 30,
    grab_keyboard = 31,
    ungrab_keyboard = 32,
    grab_key = 33,
    ungrab_key = 34,
    allow_events = 35,
    grab_server = 36,
    ungrab_server = 37,
    query_pointer = 38,
    get_motion_events = 39,
    translate_coordinates = 40,
    warp_pointer = 41,
    set_input_focus = 42,
    get_input_focus = 43,
    query_keymap = 44,
    open_font = 45,
    close_font = 46,
    query_font = 47,
    query_text_extents = 48,
    list_fonts = 49,
    list_fonts_with_info = 50,
    set_font_path = 51,
    get_font_path = 52,
    create_pixmap = 53,
    free_pixmap = 54,
    create_gc = 55,
    change_gc = 56,
    copy_gc = 57,
    set_dashes = 58,
    set_clip_rectangles = 59,
    free_gc = 60,
    clear_area = 61,
    copy_area = 62,
    copy_plane = 63,
    poly_point = 64,
    poly_line = 65,
    poly_segment = 66,
    poly_rectangle = 67,
    poly_arc = 68,
    fill_poly = 69,
    poly_fill_rectangle = 70,
    poly_fill_arc = 71,
    put_image = 72,
    get_image = 73,
    poly_text_8 = 74,
    poly_text_16 = 75,
    image_text_8 = 76,
    image_text_16 = 77,
    create_colormap = 78,
    free_colormap = 79,
    copy_colormap_and_free = 80,
    install_colormap = 81,
    uninstall_colormap = 82,
    list_installed_colormaps = 83,
    alloc_color = 84,
    alloc_named_color = 85,
    alloc_color_cells = 86,
    alloc_color_planes = 87,
    free_colors = 88,
    store_colors = 89,
    store_named_color = 90,
    query_colors = 91,
    lookup_color = 92,
    create_cursor = 93,
    create_glyph_cursor = 94,
    free_cursor = 95,
    recolor_cursor = 96,
    query_best_size = 97,
    query_extension = 98,
    list_extensions = 99,
    change_keyboard_mapping = 100,
    get_keyboard_mapping = 101,
    change_keyboard_control = 102,
    get_keyboard_control = 103,
    bell = 104,
    change_pointer_control = 105,
    get_pointer_control = 106,
    set_screen_saver = 107,
    get_screen_saver = 108,
    change_hosts = 109,
    list_hosts = 110,
    set_access_control = 111,
    set_close_down_mode = 112,
    kill_client = 113,
    rotate_properties = 114,
    force_screen_saver = 115,
    set_pointer_mapping = 116,
    get_pointer_mapping = 117,
    set_modifier_mapping = 118,
    get_modifier_mapping = 119,
    no_operation = 127,
};

pub const EventCode = enum(u8) {
    /// Error from server.
    @"error" = 0, // not strictly an X11 "Event"
    /// Reply to client request.
    reply = 1, // not strictly an X11 "Event"
    /// Event sent when keyboard button is pressed.
    key_press = 2,
    /// Event sent when keyboard button is released.
    key_release = 3,
    /// Event sent when pointer button is pressed.
    button_press = 4,
    /// Event sent when pointer button is released.
    button_release = 5,
    /// Event sent when pointer moves.
    motion_notify = 6,
    /// Event sent when pointer enters window.
    enter_notify = 7,
    /// Event sent when pointer leaves window.
    leave_notify = 8,
    /// Event sent when input focus enters window.
    focus_in = 9,
    /// Event sent when input focus leaves window.
    focus_out = 10,
    /// Event sent when keymap has changed upon focus.
    keymap_notify = 11,
    /// Event sent when window contents have been invalidated.
    expose = 12,
    /// Event sent when graphics context regions have been invalidated.
    graphics_exposure = 13,
    /// Event sent when graphics context regions could have been invalidated.
    no_exposure = 14,
    /// Event sent when window visibility has changed.
    visibility_notify = 15,
    /// Event sent when window has been created.
    create_notify = 16,
    /// Event sent when window has been destroyed.
    destroy_notify = 17,
    /// Event sent when window is unmapped.
    unmap_notify = 18,
    /// Event sent when window is mapped.
    map_notify = 19,
    /// Event sent on request to unmap window without override-redirect.
    map_request = 20,
    reparent_notify = 21,
    configure_notify = 22,
    configure_request = 23,
    gravity_notify = 24,
    resize_request = 25,
    circulate_notify = 26,
    circulate_request = 27,
    property_notify = 28,
    selection_clear = 29,
    selection_request = 30,
    selection_notify = 31,
    colormap_notify = 32,
    client_message = 33,
    mapping_notify = 34,
    ge_generic = 35,
};

pub const GCFunction = enum(c_int) {
    clear = 0,
    @"and" = 1,
    and_reverse = 2,
    copy = 3,
    and_inverted = 4,
    noop = 5,
    xor = 6,
    @"or" = 7,
    nor = 8,
    equiv = 9,
    invert = 10,
    or_reverse = 11,
    copy_inverted = 12,
    or_inverted = 13,
    nand = 14,
    set = 15,
};

pub const CreateGCMask = packed struct(u32) {
    function: bool = false,
    plane_mask: bool = false,
    foreground: bool = false,
    background: bool = false,
    line_width: bool = false,
    line_style: bool = false,
    cap_style: bool = false,
    join_style: bool = false,
    fill_style: bool = false,
    fill_rule: bool = false,
    tile: bool = false,
    stipple: bool = false,
    tile_stipple_origin_x: bool = false,
    tile_stipple_origin_y: bool = false,
    font: bool = false,
    subwindow_mode: bool = false,
    graphics_exposures: bool = false,
    clip_origin_x: bool = false,
    clip_origin_y: bool = false,
    clip_mask: bool = false,
    dash_offset: bool = false,
    dash_list: bool = false,
    arc_mode: bool = false,
    reserved: u9 = 0,
};

pub const CreateWindowMask = packed struct(u32) {
    back_pixmap: bool = false,
    back_pixel: bool = false,
    border_pixmap: bool = false,
    border_pixel: bool = false,
    bit_gravity: bool = false,
    win_gravity: bool = false,
    backing_store: bool = false,
    backing_planes: bool = false,
    backing_pixel: bool = false,
    override_redirect: bool = false,
    save_under: bool = false,
    event_mask: bool = false,
    dont_propagate: bool = false,
    colormap: bool = false,
    cursor: bool = false,
    reserved: u17 = 0,
};

pub const EventMask = packed struct(u32) {
    key_press: bool = false,
    key_release: bool = false,
    button_press: bool = false,
    button_release: bool = false,
    enter_window: bool = false,
    leave_window: bool = false,
    pointer_motion: bool = false,
    pointer_motion_hint: bool = false,
    button_1_motion: bool = false,
    button_2_motion: bool = false,
    button_3_motion: bool = false,
    button_4_motion: bool = false,
    button_5_motion: bool = false,
    button_motion: bool = false,
    keymap_state: bool = false,
    exposure: bool = false,
    visibility_change: bool = false,
    structure_notify: bool = false,
    resize_redirect: bool = false,
    substructure_notify: bool = false,
    substructure_redirect: bool = false,
    focus_change: bool = false,
    property_change: bool = false,
    color_map_change: bool = false,
    owner_grab_button: bool = false,
    reserved: u7 = 0,
};

// TODO: generate compile error if XCB types are not u32
pub const id_t = u32;

pub const button_t = xcb.xcb_button_t;
pub const connection_t = xcb.xcb_connection_t;
pub const drawable_t = xcb.xcb_drawable_t;
pub const font_t = xcb.xcb_font_t;
pub const gcontext_t = xcb.xcb_gcontext_t;
pub const keycode_t = xcb.xcb_keycode_t;
pub const rectangle_t = xcb.xcb_rectangle_t;
pub const screen_t = xcb.xcb_screen_t;
pub const screen_iterator_t = xcb.xcb_screen_iterator_t;
pub const setup_t = xcb.xcb_setup_t;
pub const timestamp_t = xcb.xcb_timestamp_t;
pub const visualid_t = xcb.xcb_visualid_t;
pub const window_t = xcb.xcb_window_t;

pub const generic_error_t = xcb.xcb_generic_error_t;
pub const request_error_t = xcb.xcb_request_error_t;
pub const value_error_t = xcb.xcb_value_error_t;

pub const generic_event_t = xcb.xcb_generic_event_t;
pub const key_press_event_t = xcb.xcb_key_press_event_t;
pub const key_release_event_t = xcb.xcb_key_release_event_t;
pub const button_press_event_t = xcb.xcb_button_press_event_t;
pub const button_release_event_t = xcb.xcb_button_release_event_t;

pub const void_cookie_t = xcb.xcb_void_cookie_t;
pub const intern_atom_cookie_t = xcb.xcb_intern_atom_cookie_t;

pub fn change_gc(
    conn: *connection_t,
    gc: gcontext_t,
    value_mask: CreateGCMask,
    values: ?*const anyopaque,
) void_cookie_t {
    return xcb.xcb_change_gc(conn, gc, value_mask, values);
}

pub fn close_font(conn: *connection_t, font: font_t) void_cookie_t {
    return xcb.xcb_close_font(conn, font);
}

pub fn connect(displayName: ?[:0]const u8, screen: ?*c_int) *connection_t {
    if (xcb.xcb_connect(@ptrCast(displayName), screen)) |c| {
        return c;
    } else {
        @panic("xcb_connect should never return NULL");
    }
}

pub fn connection_has_error(conn: *connection_t) Result {
    return @enumFromInt(xcb.xcb_connection_has_error(conn));
}

pub fn create_gc(
    conn: *connection_t,
    gc: gcontext_t,
    drawable: drawable_t,
    value_mask: CreateGCMask,
    values: ?*const anyopaque,
) void_cookie_t {
    return xcb.xcb_create_gc(
        conn,
        gc,
        drawable,
        @bitCast(value_mask),
        values,
    );
}

pub fn create_window(
    conn: *connection_t,
    depth: u8,
    window: window_t,
    parent: window_t,
    x: i16,
    y: i16,
    width: u16,
    height: u16,
    border: u16,
    class: u16,
    visual: visualid_t,
    value_mask: CreateWindowMask,
    values: ?*const anyopaque,
) void_cookie_t {
    return xcb.xcb_create_window(
        conn,
        depth,
        window,
        parent,
        x,
        y,
        width,
        height,
        border,
        class,
        visual,
        @bitCast(value_mask),
        values,
    );
}

pub fn destroy_window(conn: *connection_t, window: window_t) void_cookie_t {
    return xcb.xcb_destroy_window(conn, window);
}

pub fn disconnect(conn: *connection_t) void {
    xcb.xcb_disconnect(conn);
}

pub fn flush(conn: *connection_t) Result {
    const result = xcb.xcb_flush(conn);
    return if (result > 0) .ok else @enumFromInt(result);
}

pub fn free_gc(conn: *connection_t, gc: gcontext_t) void_cookie_t {
    return xcb.xcb_free_gc(conn, gc);
}

pub fn generate_id(conn: *connection_t) id_t {
    return xcb.xcb_generate_id(conn);
}

pub fn get_setup(conn: *connection_t) *const setup_t {
    return xcb.xcb_get_setup(conn);
}

pub fn image_text_8(
    conn: *connection_t,
    drawable: drawable_t,
    gc: gcontext_t,
    x: i16,
    y: i16,
    string: []const u8,
) void_cookie_t {
    return xcb.xcb_image_text_8(
        conn,
        @intCast(string.len),
        drawable,
        gc,
        x,
        y,
        @ptrCast(string.ptr),
    );
}

pub fn map_window(conn: *connection_t, window: window_t) void_cookie_t {
    return xcb.xcb_map_window(conn, window);
}

pub fn open_font(
    conn: *connection_t,
    font: font_t,
    name: []const u8,
) void_cookie_t {
    return xcb.xcb_open_font(
        conn,
        font,
        @intCast(name.len),
        @ptrCast(name.ptr),
    );
}

pub fn poly_fill_rectangle(
    conn: *connection_t,
    drawable: drawable_t,
    gc: gcontext_t,
    rectangles: []const rectangle_t,
) void_cookie_t {
    return xcb.xcb_poly_fill_rectangle(
        conn,
        drawable,
        gc,
        @intCast(rectangles.len),
        @ptrCast(rectangles.ptr),
    );
}

pub fn poly_rectangle(
    conn: *connection_t,
    drawable: drawable_t,
    gc: gcontext_t,
    rectangles: []rectangle_t,
) void_cookie_t {
    return xcb.xcb_poly_rectangle(
        conn,
        drawable,
        gc,
        rectangles.len,
        rectangles.ptr,
    );
}

pub fn screen_next(iter: *screen_iterator_t) void {
    xcb.xcb_screen_next(iter);
}

pub fn setup_roots_iterator(setup: *const setup_t) screen_iterator_t {
    return xcb.xcb_setup_roots_iterator(setup);
}

pub fn unmap_window(conn: *connection_t, window: window_t) void_cookie_t {
    return xcb.xcb_unmap_window(conn, window);
}

pub fn wait_for_event(conn: *connection_t) ?*generic_event_t {
    return xcb.xcb_wait_for_event(conn);
}
