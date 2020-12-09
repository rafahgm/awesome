local awful = require('awful');
local wibox = require('wibox');
local dpi = require('beautiful').xresources.apply_dpi;
local gears = require('gears');
local utils = require('utils');
local theme = require('themes.transparent.definitions');
local naughty = require('naughty');

local widget_icon_dir = gears.filesystem.get_configuration_dir() .. 'widgets/notification_center/images/'

local notif_header = wibox.widget {
    text = 'Notificações',
    font = theme.font,
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox
}

local function create_notification(app_name, title, body)
    local notification_header = wibox.widget {
        widget = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        {
            widget = wibox.container.background,
            bg = "#FEFEFE99",
            shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, dpi(10))
            end,
            {
                widget = wibox.container.margin,
                left = dpi(10), right = dpi(10), top = dpi(5), bottom = dpi(5),
                {
                    layout = wibox.layout.align.horizontal,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            widget = wibox.widget.textbox,
                            font = theme.fonts.im,
                            markup = utils.colorize_text("󰇮  ", "#242424")
                        },
                        {
                            widget = wibox.widget.textbox,
                            font = theme.fonts.rsb,
                            markup = utils.colorize_text(app_name, "#242424")
                        },
                    },
                    nil,
                    {
                        widget = wibox.widget.textbox,
                        font = theme.fonts.rsb,
                        markup = utils.colorize_text("24m atrás", "#242424")
                    }
                }
            }
        }
    }
    
    local notification_body = wibox.widget {
        widget = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        {
            widget = wibox.container.background,
            bg = "#F0F0F080",
            shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, dpi(10))
            end,
            {
                widget = wibox.container.margin,
                margins = dpi(10),
                {
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox,
                        font = theme.fonts.rrb,
                        markup = utils.colorize_text(title, "#242424")
                    }, 
                    {
                        widget = wibox.widget.textbox,
                        font = theme.font,
                        markup = utils.colorize_text(body, "#242424")
                    }
                    
                }
            }
        }
    }
    
    local notification = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        notification_header,
        notification_body
    }
    
    return notification
end

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
        bg = "#FFFFFF70",
    }
    
    local notif_container = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5)
    }
    
    local back_button = utils.make_button(theme.icons.chevron_double_left, 5, "#FFFFFF90", "#FFFFFFFF", function()
        notif_center.visible = false;
    end)
    local create_notification_button = utils.make_button("+", 5, "#FFFFFF90", "#FFFFFFFF", function()
        notif_container:insert(1, create_notification())
    end)
    
    
    notif_center:setup {
        expand = 'none',
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10),
        {
            expand = 'none',
            layout = wibox.layout.align.horizontal,
            back_button,
            notif_header,
            create_notification_button
        },
        notif_container
    }
    
    naughty.connect_signal('request::display', function(n)
        notif_container:insert(1, create_notification(n.app_name, n.title, n.message))
    end)
    
    _G.root.elements.notif_center = notif_center
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not _G.root.elements.notif_center or not _G.root.elements.notif_center[s.index] then notif_center(s) end
    end)
end