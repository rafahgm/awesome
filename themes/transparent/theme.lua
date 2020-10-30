local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local xrdb = beautiful.xresources.get_current_theme();

local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir().."themes/transparent/"

local theme = {}

theme.useless_gap = 6
-- Global
theme.global = {
    m = 5,
}
-- Colors
theme.colors = {
    x1 = xrdb.color1,
    x4 = xrdb.color4,
    w = "#FEFEFE",
    t = "#00000000"
}

-- Fonts
theme.font = "Roboto 14"
theme.fonts = {
    im = "Material Design Icons 14"
}

-- Icons
theme.icons = {
    arch = "󰣇",
    time = "󰥔",
    date = "󰃮"
}

theme.wallpaper = theme_path.."background.jpg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Topbar
theme.topbar = {
    w = 30,
    h = 30,
    dw = 230,
}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
