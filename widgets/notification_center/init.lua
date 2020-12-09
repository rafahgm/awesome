local awful = require('awful');
local wibox = require('wibox');
local dpi = require('beautiful').xresources.apply_dpi;
local gears = require('gears');
local utils = require('utils');
local theme = require('themes.transparent.definitions');
local naughty = require('naughty');
local create_notification = require('widgets.notification_center.notification');
local nord = require('theme_engine');
local animation = require('widgets.animation_test.animation');
local glib = require('lgi').GLib
local widget_icon_dir = gears.filesystem.get_configuration_dir() .. 'widgets/notification_center/images/'

local function notif_center(s)
    local notif_center = wibox {
        screen = s,
        ontop = true,
        visible = false,
        type = 'splash',
        width = dpi(400),
        height = s.workarea.height + theme.topbar.h + theme.global.m,
        x = s.workarea.x + s.workarea.width - dpi(400) ,
        y = 0,
        bg = nord.colors.c0 .. "AA",
    }
    
    local back_button = utils.make_button(theme.icons.chevron_double_left, 10, nord.colors.c0, nord.colors.c1, function()
        animation.start_animation(Elements.notif_center, 300, {x = s.workarea.width}, 'inExpo')
        glib.timeout_add(glib.PRIORITY_DEFAULT, 350, function()
            notif_center.visible = false;
            return false;
        end)
    end)
    
    local header = wibox.widget {
        widget = wibox.container.margin,
        margins = dpi(5),
        {
            layout = wibox.layout.align.horizontal,
            back_button,
            {
                widget = wibox.widget.textbox,
                text = "Central de notificações",
                font = nord.fonts.inter.large.regular,
                align = "center"
            },
            nil,
        }
    }
    
    local notif_container = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5)
    }
    
    
    notif_center:setup {
        expand = 'none',
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10),
        header,
        notif_container
    }
    
    naughty.connect_signal('request::display', function(n)
        notif_container:insert(1, create_notification(n.app_name, n.title, n.message))
    end)
    
    Elements.notif_center = notif_center
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not Elements.notif_center then notif_center(s) end
    end)
end