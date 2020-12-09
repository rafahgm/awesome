local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local theme = require("beautiful")
local utils = require("utils")

-- TODO: CLEAN UP THIS MESS
local make_vol_osd = function(s)
    -- TODO: Move these to theme.lua
    local osd_height = dpi(100)
    local osd_width = dpi(300)
    local osd_x_offset = dpi(300)

    -- Label next to icon
    local osd_label = wibox.widget {
        text = "Volume",
        font = "Inter Bold 12",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox,
    }
    -- Label with volume value: ex: 38%
    local osd_value = wibox.widget {
        text = "0%",
        font = "Inter Bold 12",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    }
    -- Icon next to label
    local icon = wibox.widget {
        {
            widget = wibox.widget.textbox,
            text = "󰕾",
            font = "Material Icons Desktop 24",
            valign = "center",
            align = "center"
        },
        layout = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
    }
    -- Header (icon, label, value)
    local osd_header = wibox.widget {
        widget = wibox.container.background,
        width = dpi(300),
        bg = theme.colors.x6,
        {
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                forced_height = dpi(48),
                {
                    icon,
                    osd_label,
                    layout = wibox.layout.align.horizontal,
                },
                nil,
                osd_value,
            },
            layout = wibox.container.margin,
            left = dpi(24),
            right = dpi(24)
        }
        
    }
    
    -- Centered slider
    local slider_osd = wibox.widget {
        nil,
        {
            id = "vol_osd_slider",
            bar_shape = gears.shape.rounded_rect,
            bar_height = dpi(2),
            bar_color = "#F2F2F250",
            bar_active_color = "#f2f2f2EE",
            handle_color = "#FFFFFF",
            handle_shape = gears.shape.circle,
            handle_width = dpi(15),
            handle_border_color = "#00000012",
            handle_border_width = dpi(1),
            maximum = 100,
            widget = wibox.widget.slider,
        },
        nil,
        expand = 'none',
        layout = wibox.layout.align.vertical,
    }
    -- Slider wrapper
    local volume_slider_osd = wibox.widget {
        {
            slider_osd,
            spacing = dpi(24),
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.container.margin,
        left = dpi(24),
        right = dpi(24)
    }
    
    local vol_osd_slider = slider_osd.vol_osd_slider
    
    vol_osd_slider:connect_signal("property::value",function()
        local volume_level = vol_osd_slider:get_value()
        awful.spawn("pamixer --set-volume ".. volume_level)
        osd_value.text = volume_level .. "%"
    end)

    -- Create the wibox
    local volume_osd_overlay = wibox {
        widget = {
            
        },
        ontop = true,
        visible = false,
        type = "notification",
        screen = s,
        height = osd_height,
        width = osd_width,
        maximum_width = dpi(10),
        maximum_height = dpi(10),
        offset = dpi(5),
        shape = gears.shape.rectangle,
        bg = "#00000000",
        preferred_anchors = "middle",
        preferred_positions = {"left", "right", "top", "bottom"},
        x = (s.workarea.width / 2) - (osd_width / 2),
        y = (s.workarea.height / 2) - (osd_height / 2) + osd_x_offset,
    }
    
    volume_osd_overlay:setup{
        {
            osd_header,
            volume_slider_osd,
            layout = wibox.layout.fixed.vertical,
        },
        bg = theme.colors.x0,
        shape = gears.shape.rectangle,
        widget = wibox.container.background,
    }
    
    -- Stop timer when mouse enter
    volume_osd_overlay:connect_signal("mouse::enter",
    function()
        _G.awesome.emit_signal("module::volume_osd:stop")
    end)
    
    -- Restart timer when mouse leaves
    volume_osd_overlay:connect_signal("mouse::leave", function()
        _G.awesome.emit_signal("module::volume_osd:restart")
    end)

    -- Timer
    local hide_osd = gears.timer {
        timeout = 2,
        autostart = true,
        callback = function()
            Elements.volume_osd.visible = false
        end
    }
    
    _G.awesome.connect_signal("module::volume_osd:stop",function() hide_osd:stop() end)
    
    _G.awesome.connect_signal("module::volume_osd:restart",function() hide_osd:again() end)

    -- Function to change volume
    local set_volume = function(volume) 
        if not volume_osd_overlay.visible then
            volume_osd_overlay.visible = true
        end

        -- Restart hide timer
        hide_osd:again()
        vol_osd_slider:set_value(volume)
    end
    
    Elements.volume_osd= volume_osd_overlay
    Elements.volume_osd.set_volume = set_volume
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not Elements.volume_osd then make_vol_osd(s) end
    end)
end
