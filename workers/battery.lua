local awful = require("awful")

local awful = require("awful")
local utils = require("utils")
local theme = require("beautiful")

local battery_file = "/sys/class/power_supply/BAT0/capacity"
local charger_file = "/sys/class/power_supply/ADP0/online"
local charger_script = [[
    sh -c '
    acpi_listen | grep --line-buffered ac_adapter
    '
]]

awful.widget.watch("cat "..battery_file, 15, function(_, stdout)
    local formated_text = string.gsub(stdout, "\n", "") .. "%"
    _G.root.elements.battery_icons[awful.screen.focused().index].battery_text:set_text(formated_text)
    -- utils.obj_debug(_G.root.elements.battery_icons[awful.screen.focused().index].battery_text)
end)

local function handle_charging_state() 
    awful.spawn.easy_async_with_shell("cat "..charger_file, function (out)
        local online = tonumber(out) == 1

        if online then
            _G.root.elements.battery_icons[awful.screen.focused().index].battery_icon:set_text(theme.icons.battery.charging.full)
        else
            _G.root.elements.battery_icons[awful.screen.focused().index].battery_icon:set_text(theme.icons.battery.discharging.full)
        end
        
    end)
end

-- Init icon
handle_charging_state()

-- Kill old listeners
awful.spawn.easy_async_with_shell("ps x | grep \"acpi_listen\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Update charger status with each line printed
    awful.spawn.with_line_callback(charger_script, {
        stdout = function(_)
            handle_charging_state()
        end
    })
end)