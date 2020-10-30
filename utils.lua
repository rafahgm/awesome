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

return utils