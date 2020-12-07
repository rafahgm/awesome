local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local xrdb = beautiful.xresources.get_current_theme();

local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir().."themes/transparent/"

local theme = {}


theme.border_width = 1;
theme.border_focus = xrdb.color4
theme.border_normal = "#FFFFFF"

theme.useless_gap = dpi(5)

-- Global
theme.global = {
    m = dpi(5),
}
-- Colors
theme.colors = {
    x0 = xrdb.color0,
    x1 = xrdb.color1,
    x2 = xrdb.color2,
    x3 = xrdb.color3,
    x4 = xrdb.color4,
    x5 = xrdb.color5,
    x6 = xrdb.color6,
    x7 = xrdb.color7,
    x8 = xrdb.color8,
    x9 = xrdb.color9,
    x10 = xrdb.color10,
    x11 = xrdb.color11,
    x12 = xrdb.color12,
    x13 = xrdb.color13,
    x14 = xrdb.color14,
    x15 = xrdb.color15,
    w = "#FEFEFE",
    t = "#FFFFFF01",
    b = "#0F0F0F",
}

-- Fonts
theme.font = "Roboto 14"
theme.fonts = {
    im = "Material Design Icons Desktop 18",
    il = "Material Design Icons Desktop 48",
}

-- Icons
theme.icons = {
    arch = "󰣇",
    time = "󰥔",
    date = "󰃮",
    power = "󰐥",
    restart = "󰜉",
    suspend = "󰋣",
    volume_max = "󰕾",
    wifi = "󰖩",
    back = "󰌍",
    battery = {
        charging = {
            full = "󰂄"
        },
        discharging = {
            full = "󰁹"
        }
    },
    volume = {
        high = "󰕾",
        medium = "󰖀",
        low = "󰕿",
        mute = "󰝟",
        off = "󰖁",
        up = "󰝝",
        down = "󰝞"
    }
}

theme.wallpaper = theme_path.."background.jpg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Topbar
theme.topbar = {
    w = 30,
    h = 30,
    dw = 240,
    utilities = {
        wifi = true,
        battery = true,
        pac = false,
        mem = false,
        volume = true,
    }
}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
