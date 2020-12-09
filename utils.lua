local awful = require("awful")
local gears = require("gears")
local wibox = require('wibox');
local theme = require('themes.transparent.definitions');

local utils = {}

utils.xmessage = function(msg)
    awful.spawn("xmessage '"..msg.."'")
end

utils.rounded = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

utils.colorize_text = function(text,foreground, background)
    if background then
        return "<span foreground='"..foreground.."' background='"..background.."'>"..text.."</span>"
    else
        return "<span foreground='"..foreground.."'>"..text.."</span>"
    end
end

utils.pads_spaces_both = function(text, npads)
    local padded_text = ""
    for i=1,npads do
        padded_text = " "..padded_text
    end
    
    padded_text = padded_text..text
    
    for i=1,npads do
        padded_text = padded_text.." "
    end
    
    return padded_text
end

utils.obj_debug = function(obj)
    utils.xmessage(gears.debug.dump_return(obj))
end

-- Lighten a given color
utils.lighten = function(color, percent)
    local amount = math.floor(255 * percent)
    
    local r = tonumber(string.sub(color, 2, 3), 16)
    local g = tonumber(string.sub(color, 4, 5), 16)
    local b = tonumber(string.sub(color, 6, 7), 16)
    
    if r + amount > 255 then r = 255 else r = r + amount end
    if g + amount > 255 then g = 255 else g = g + amount end
    if b + amount > 255 then b = 255 else b = b + amount end
    
    return string.format("#%02x%02x%02x",r,g,b)
end

utils.make_button = function(text, size, bg, hover_bg, action)
    local button = wibox.widget {
        widget = wibox.container.background,
        bg = bg,
        {
            widget = wibox.container.margin,
            bottom = size, top = size, right = size, left = size,
            {
                widget = wibox.widget.textbox,
                text = text,
                font = theme.font,
            }
        }
    }

    button:connect_signal('mouse::enter', function(c) c:set_bg(hover_bg) end)
    button:connect_signal('mouse::leave', function(c) c:set_bg(bg) end)

    button:buttons(gears.table.join(button:buttons(), awful.button({}, 1, nil, action)))

    return button
end

return utils