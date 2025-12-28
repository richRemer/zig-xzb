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

pub const EventCode = enum(u16) {
    key_press = 2,
    key_release = 3,
    button_press = 4,
    button_release = 5,
    motion_notify = 6,
    enter_notify = 7,
    leave_notify = 8,
    focus_in = 9,
    focus_out = 10,
    keymap_notify = 11,
    expose = 12,
    graphics_exposure = 13,
    no_exposure = 14,
    visibility_notify = 15,
    create_notify = 16,
    destroy_notify = 17,
    unmap_notify = 18,
    map_notify = 19,
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

pub const connection_t = xcb.xcb_connection_t;
pub const screen_t = xcb.xcb_screen_t;
pub const screen_iterator_t = xcb.xcb_screen_iterator_t;
pub const setup_t = xcb.xcb_setup_t;
pub const visualid_t = xcb.xcb_visualid_t;
pub const window_t = xcb.xcb_window_t;

pub const generic_error_t = xcb.xcb_generic_error_t;
pub const request_error_t = xcb.xcb_request_error_t;
pub const value_error_t = xcb.xcb_value_error_t;

pub const generic_event_t = xcb.xcb_generic_event_t;
pub const key_press_event_t = xcb.xcb_key_press_event_t;
pub const key_release_event_t = xcb.xcb_key_release_event_t;
pub const button_press_event_t = xcb.xcb_button_press_event_t;

pub const void_cookie_t = xcb.xcb_void_cookie_t;
pub const intern_atom_cookie_t = xcb.xcb_intern_atom_cookie_t;

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

pub fn create_window(
    conn: *connection_t,
    depth: u8,
    wid: window_t,
    parent: window_t,
    x: i16,
    y: i16,
    width: u16,
    height: u16,
    border: u16,
    class: u16,
    visual: visualid_t,
    value_mask: u32,
    values: ?*const anyopaque,
) void_cookie_t {
    return xcb.xcb_create_window(
        conn,
        depth,
        wid,
        parent,
        x,
        y,
        width,
        height,
        border,
        class,
        visual,
        value_mask,
        values,
    );
}

pub fn disconnect(conn: *connection_t) void {
    xcb.xcb_disconnect(conn);
}

pub fn flush(conn: *connection_t) Result {
    return @enumFromInt(xcb.xcb_flush(conn));
}

pub fn generate_id(conn: *connection_t) u32 {
    return xcb.xcb_generate_id(conn);
}

pub fn get_setup(conn: *connection_t) *const setup_t {
    return xcb.xcb_get_setup(conn);
}

pub fn map_window(conn: *connection_t, id: u32) void_cookie_t {
    return xcb.xcb_map_window(conn, id);
}

pub fn screen_next(iter: *screen_iterator_t) void {
    xcb.xcb_screen_next(iter);
}

pub fn setup_roots_iterator(setup: *const setup_t) screen_iterator_t {
    return xcb.xcb_setup_roots_iterator(setup);
}
