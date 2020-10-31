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

return utils