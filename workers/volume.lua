local awful = require("awful")
local theme = require("beautiful")

local volume = {}

local get_vol_cmd = "pacmd list-sinks | awk '/\\* index: /{nr[NR+7];nr[NR+11]}; NR in nr'"

volume.volume_step = 5
volume.muted = false
volume.current_volume = -1
-- All things related to volume changing should go here

--[[TODO: Create a function in utils that set a minimum width for textbox, filling the needed space with whitespaces
      To when the volume widget has one digit, or none, the size doesnt change.
--]]
local function set_widget(volume, mute)
    local icon = theme.icons.volume.off
    local text = " "..volume.."%"

    if mute then
        icon = theme.icons.volume.mute
        text = ""
    elseif volume == 0 then
        icon = theme.icons.volume.low
    elseif volume < 50 then
        icon = theme.icons.volume.medium
    else
        icon = theme.icons.volume.high
    end

    _G.root.elements.volume_widget[awful.screen.focused().index].volume_icon:set_text(icon)
    _G.root.elements.volume_widget[awful.screen.focused().index].volume_text:set_text(text)
end

volume.up = function()
    -- Actually increase the volume
    awful.spawn("pamixer -i "..volume.volume_step)
    awful.spawn.easy_async_with_shell(get_vol_cmd, function(stdout)
        volume.current_volume = tonumber(stdout:match("(%d+)%% /"))
        -- TODO: Remove signal and change the value from root.elements.volume_osd
        _G.awesome.emit_signal("module::volume_osd", volume.current_volume)
        -- Space before value to separate from icon
        set_widget(volume.current_volume)
    end)
end

volume.down = function()
    -- Actually increase the volume
    awful.spawn("pamixer -d "..volume.volume_step)
    awful.spawn.easy_async_with_shell(get_vol_cmd, function(stdout)
        volume.current_volume  = tonumber(stdout:match("(%d+)%% /"))
        _G.awesome.emit_signal("module::volume_osd", volume.current_volume)
        set_widget(volume.current_volume)
    end)
end

volume.mute = function()
    awful.spawn("pamixer -t")
    volume.muted = not volume.muted
    set_widget(volume.current_volume, volume.muted)
end

-- Initialize the volume widget
awful.spawn.easy_async_with_shell(get_vol_cmd, function(stdout)
    volume.current_volume = tonumber(stdout:match("(%d+)%% /"))
    set_widget(volume.current_volume)
end)

return volume