-- Provide: daemon::volume
--      percentage (integer)
--      muted (boolean)    

local awful = require("awful")
local utils = require("utils")

local volume_old = -1
local muted_old = -1
local emit_volume_info = function()
    awful.spawn.easy_async_with_shell("pacmd list-sinks | awk '/\\* index: /{nr[NR+7];nr[NR+11]}; NR in nr'", function(stdout)
        local volume = stdout:match("(%d+)%% /")
        local muted = stdout:match("muted:(%s+)[yes]")
        local muted_int = muted and 1 or 0
        local volume_int = tonumber(volume)
        
        if volume_int ~= volume_old or muted_int ~= muted_old then
            _G.awesome.emit_signal("daemon::volume", volume_int, muted)
            volume_old = volume_int
            muted_old = muted_int
        end
    end)
end

emit_volume_info()

local volume_script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]

-- Kill old pactl subscribe processess
awful.spawn.easy_async({"pkill", "--full", "--uid", os.getenv("USER"), "^pactl subscribe"}, function()
    awful.spawn.with_line_callback(volume_script, {
        stdout = function(line)
            emit_volume_info()
        end
    })
end)