-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local utils = require("utils")
local tile = require("layouts.tile");

_G.root.elements = {}
_G.preselect = {}

-- {{{ Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- Autostart programs
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

-- {{{ Themes
local themes = {"default", "gtk", "sky", "xresources", "zenburn", "transparent"}
local theme_name = themes[6]
beautiful.init(gears.filesystem.get_configuration_dir().."themes/"..theme_name.."/theme.lua")
-- }}}

-- {{{ Tag
-- Table of layouts to cover with awful.layout.inc, order matters.
_G.tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.fair,
        tile,
    })
end)
-- }}}

-- {{{ Wallpaper

_G.screen.connect_signal("request::wallpaper", function(s)
    local wallpapers = {}
    awful.spawn.easy_async("ls /home/rafael/.local/share/wallpapers", function(stdout)
        for s in stdout:gmatch("[^\r\n]+") do
            table.insert(wallpapers, s)
        end
        gears.wallpaper.maximized("/home/rafael/.local/share/wallpapers/" .. wallpapers[math.random(#wallpapers)], s, true)
    end)
end)

_G.screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[2])
end)

-- }}}


-- Configs
require("keys")
require("rules")
require("titlebars")
require("notifications")
-- require("widgets.topbar")()
require("widgets.unified_topbar")()
-- require("widgets.volumeosd")()
-- require("widgets.powermenu")()
-- require("workers.battery")
