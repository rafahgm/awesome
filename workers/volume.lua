local awful = require("awful")

local volume = {}

local get_vol_cmd = "pacmd list-sinks | awk '/\\* index: /{nr[NR+7];nr[NR+11]}; NR in nr'"

volume.volume_step = 5
-- All things related to volume changing should go here
volume.up = function()
    -- Actually increase the volume
    awful.spawn("pamixer -i "..volume.volume_step)
    awful.spawn.easy_async_with_shell(get_vol_cmd, function(stdout)
        local volume = stdout:match("(%d+)%% /")
        _G.awesome.emit_signal("module::volume_osd", tonumber(volume))
    end)
end

volume.down = function()
    -- Actually increase the volume
    awful.spawn("pamixer -d "..volume.volume_step)
    awful.spawn.easy_async_with_shell(get_vol_cmd, function(stdout)
        local volume = stdout:match("(%d+)%% /")
        _G.awesome.emit_signal("module::volume_osd", tonumber(volume))
    end)
end

volume.mute = function()
end

return volume