local awful = require('awful');
local wibox = require('wibox');
local theme = require('themes.transparent.definitions');
local nord = require('theme_engine');
local taglist = require("widgets.unified_topbar.taglist");
local gears = require('gears');
local animation = require('widgets.animation_test.animation');

local widget_margin = 10;

local function clock()
    local clock = wibox.widget {
        widget = wibox.widget.textclock,
        font = nord.fonts.inter.medium.regular,
        refresh = 60,
        format = '%H:%M',
    }
    
    return clock
end

local function battery()
    local battery = wibox.widget {
        widget = wibox.widget.textbox,
        text = nord.icons.fontawesome.battery_charging,
        font = nord.fonts.fontawesome.solid.medium,
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
        text = nord.icons.fontawesome.volume.max,
        font = nord.fonts.fontawesome.solid.medium,
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
        text = nord.icons.fontawesome.wifi,
        font = nord.fonts.fontawesome.solid.medium,
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

local function notifications(screen)
    local notif = wibox.widget {
        
        widget = wibox.widget.textbox,
        text = nord.icons.fontawesome.bell,
        font = nord.fonts.fontawesome.solid.medium,
    }

    notif:buttons(gears.table.join(notif:buttons(), awful.button({}, 1, nil, function()
        -- Handle animation
       Elements.notif_center.visible = true;
       Elements.notif_center.x = screen.workarea.width;
       animation.start_animation(Elements.notif_center, 300, {x = screen.workarea.width - Elements.notif_center.width}, 'outExpo')
    end)))

    return notif
end

local function power_button() 
    local power_button = wibox.widget {
        
        widget = wibox.widget.textbox,
        text = nord.icons.fontawesome.power,
        font = nord.fonts.fontawesome.solid.medium,
    }

    power_button:buttons(gears.table.join(power_button:buttons(), awful.button({}, 1, nil, function()
        Elements.powermenu.visible = not Elements.powermenu.visible
    end)))

    return power_button
end

local function make_topbar(screen)
    local container = wibox {
        screen = screen,
        width = screen.workarea.width -  2 * theme.global.m,
        height = theme.topbar.h,
        visible = true,
        type = "normal",
        bg = nord.colors.c0 .. "AA",
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
                notifications(screen)
                
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
    awful.screen.connect_for_each_screen(make_topbar)
end