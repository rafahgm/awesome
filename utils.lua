local awful = require("awful")
local gears = require("gears")

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

return utils