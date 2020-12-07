local awful = require('awful');
local wibox = require('wibox');
local theme = require('themes.transparent.definitions');

local widget_margin = 5;

local function clock()
    local clock = wibox.widget {
        widget = wibox.widget.textclock,
        font = theme.font,
        refresh = 60,
        format = '%H:%M',
    }
    
    return clock
end

local function battery()
    local battery = wibox.widget {
        widget = wibox.widget.textbox,
        text = theme.icons.battery.discharging.full,
        font = theme.fonts.im,
    }

    return battery
end

local function volume()
    local volume = wibox.widget {
        
          widget = wibox.widget.textbox,
          text = theme.icons.volume.high,
          font = theme.fonts.im,
    }

    return volume
end

local function topbar(screen)
    local container = wibox {
        screen = screen,
        width = screen.workarea.width -  2 * theme.global.m,
        height = theme.topbar.h,
        visible = true,
        type = "utility",
        bg = "#FFFFFF70",
        valign = "center",
        x = screen.workarea.x + theme.global.m,
        y = theme.global.m,
    }
    
    container:struts({top = theme.topbar.h + theme.global.m})
    
    container:setup {
        layout = wibox.layout.align.horizontal,
        nil,
        nil,
        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.container.margin,
                left = widget_margin,
                right = widget_margin,
                volume()
            },
            {
                layout = wibox.container.margin,
                left = widget_margin,
                right = widget_margin,
                battery()
                
            },
            {
                layout = wibox.container.margin,
                left = widget_margin,
                right = widget_margin + 5,
                clock()
                
            }
            
        }
        
    }
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not _G.root.elements.topbar or not _G.root.elements.topbar[s.index] then topbar(s) end
    end)
end