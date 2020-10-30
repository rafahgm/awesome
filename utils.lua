local awful = require("awful")
local utils = {}

utils.xmessage = function(msg)
    awful.spawn("xmessage '"..msg.."'")
end

return utils