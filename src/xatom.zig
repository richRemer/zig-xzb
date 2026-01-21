pub const none: c_int = 0;

pub const selection = struct {
    pub const primary: c_int = 1;
    pub const secondary: c_int = 2;
};

pub const property = struct {
    pub const cut_buffer0: c_int = 9;
    pub const cut_buffer1: c_int = 10;
    pub const cut_buffer2: c_int = 11;
    pub const cut_buffer3: c_int = 12;
    pub const cut_buffer4: c_int = 13;
    pub const cut_buffer5: c_int = 14;
    pub const cut_buffer6: c_int = 15;
    pub const cut_buffer7: c_int = 16;
    pub const rgb_best_map: c_int = 25;
    pub const rgb_blue_map: c_int = 26;
    pub const rgb_default_map: c_int = 27;
    pub const rgb_gray_map: c_int = 28;
    pub const rgb_green_map: c_int = 29;
    pub const rgb_red_map: c_int = 30;
    pub const resource_manager: c_int = 23;
    pub const wm_command: c_int = 34;
    pub const wm_hints: c_int = 35;
    pub const wm_client_machine: c_int = 36;
    pub const wm_icon_name: c_int = 37;
    pub const wm_icon_size: c_int = 38;
    pub const wm_name: c_int = 39;
    pub const wm_normal_hints: c_int = 40;
    pub const wm_zoom_hints: c_int = 42;
    pub const wm_class: c_int = 67;
    pub const wm_transient_for: c_int = 68;
    // wm_colormap_windows
    // wm_protocols
    // wm_state
};

pub const @"type" = struct {
    pub const arc: c_int = 3;
    pub const atom: c_int = 4;
    pub const bitmap: c_int = 5;
    pub const cardinal: c_int = 6;
    pub const colormap: c_int = 7;
    pub const cursor: c_int = 8;
    pub const drawable: c_int = 17;
    pub const font: c_int = 18;
    pub const integer: c_int = 19;
    pub const pixmap: c_int = 20;
    pub const point: c_int = 21;
    pub const rectangle: c_int = 22;
    pub const rgb_color_map: c_int = 24;
    pub const string: c_int = 31;
    pub const visualid: c_int = 32;
    pub const window: c_int = 33;
    pub const wm_hints: c_int = 35;
    pub const wm_size_hints: c_int = 41;
};

pub const font = struct {
    pub const min_space: c_int = 43;
    pub const norm_space: c_int = 44;
    pub const max_space: c_int = 45;
    pub const end_space: c_int = 46;
    pub const superscript_x: c_int = 47;
    pub const superscript_y: c_int = 48;
    pub const subscript_x: c_int = 49;
    pub const subscript_y: c_int = 50;
    pub const underline_position: c_int = 51;
    pub const underline_thickness: c_int = 52;
    pub const strikeout_ascent: c_int = 53;
    pub const strikeout_descent: c_int = 54;
    pub const italic_angle: c_int = 55;
    pub const x_height: c_int = 56;
    pub const quad_width: c_int = 57;
    pub const weight: c_int = 58;
    pub const point_size: c_int = 59;
    pub const resolution: c_int = 60;
    pub const copyright: c_int = 61;
    pub const notice: c_int = 62;
    pub const font_name: c_int = 63;
    pub const family_name: c_int = 64;
    pub const full_name: c_int = 65;
    pub const cap_height: c_int = 66;
};
