local awful = require('awful');
local wibox = require('wibox');
local theme = require('themes.transparent.definitions');
local taglist = require("widgets.unified_topbar.taglist");
local gears = require('gears');
local animation = require('widgets.animation_test.animation');

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
    local battery_tooltip = awful.tooltip{
        objects = {battery},
        text = "Battery info",
        align = "bottom",
        mode = "outside",
        bg = "#FFFFFF70"
    }

    battery:connect_signal('mouse::enter', function()
        awful.spawn.easy_async("cat /sys/class/power_supply/BAT0/capacity", function(stdout)
            battery_tooltip.text = stdout
        end)
    end)
    return battery
end

local function volume()
    local volume = wibox.widget {
        widget = wibox.widget.textbox,
        text = theme.icons.volume.high,
        font = theme.fonts.im,
    }
    local battery_tooltip = awful.tooltip{
        text = "Battery info",
        align = "bottom",
        mode = "outside",
        bg = "#FFFFFF70"
    }
    battery_tooltip:add_to_object(volume)
    return volume
end

local function wireless() 
    local wifi = wibox.widget {
        
        widget = wibox.widget.textbox,
        text = theme.icons.wifi,
        font = theme.fonts.im,
    }
    local battery_tooltip = awful.tooltip{
        objects = {wifi},
        text = "Battery info",
        align = "bottom",
        mode = "outside",
        bg = "#FFFFFF70"
    }
    
    return wifi
end

local function notifications()
    local notif = wibox.widget {
        
        widget = wibox.widget.textbox,
        text = theme.icons.bell,
        font = theme.fonts.im,
    }

    notif:buttons(gears.table.join(notif:buttons(), awful.button({}, 1, nil, function() _G.root.elements.notif_center.visible = true end)))

    return notif
end

local function power_button() 
    local power_button = wibox.widget {
        
        widget = wibox.widget.textbox,
        text = theme.icons.power,
        font = theme.fonts.im,
    }

    power_button:buttons(gears.table.join(power_button:buttons(), awful.button({}, 1, nil, function()
        _G.root.elements.animated_box.visible = not _G.root.elements.animated_box.visible
        animation.start_animation(_G.root.elements.animated_box)
    end)))

    return power_button
end

local function topbar(screen)
    local container = wibox {
        screen = screen,
        width = screen.workarea.width -  2 * theme.global.m,
        height = theme.topbar.h,
        visible = true,
        type = "dock",
        bg = "#FFFFFF50",
        valign = "center",
        x = screen.workarea.x + theme.global.m,
        y = theme.global.m,
    }
    
    container:struts({top = theme.topbar.h + theme.global.m})
    
    container:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.container.margin,
                right = widget_margin,
                taglist(screen)
            }
        },
        nil,
        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.container.margin,
                left = widget_margin,
                right = widget_margin,
                wireless()
            },
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
                right = widget_margin,
                notifications()
                
            },
            {
                layout = wibox.container.margin,
                left = widget_margin,
                right = widget_margin,
                clock()
                
            },
            {
                layout = wibox.container.margin,
                left = widget_margin,
                right = widget_margin + 5,
                power_button()
            }
            
        }
        
    }
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not _G.root.elements.topbar or not _G.root.elements.topbar[s.index] then topbar(s) end
    end)
end