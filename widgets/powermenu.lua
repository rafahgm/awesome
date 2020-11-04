local wibox = require("wibox")
local theme = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local utils = require("utils")

-- TODO: Fix color meaning, right now the colors are a bit mixed and doesnt reflect the action of the button
-- TODO: Implement an semi transparent overlay that cover the whole screen and prevent clicking on ohter appliactions
-- TODO: Implement an prompt asking for confirmation before doing the button action

local function make_button(icon, text, background_color)
    local button_text = wibox.widget {
        widget = wibox.widget.textbox,
        text = text,
        font = theme.font,
        align = "center",
        valign = "center",
        visible = false,
    }
    
    local button_icon = wibox.widget{
        widget = wibox.widget.textbox,
        text = icon,
        font = theme.fonts.il,
        align = "center",
        valign = "center",
    }
    
    local button = wibox.widget {
        widget = wibox.container.background,
        bg = background_color,
        {
            layout = wibox.container.place,
            valign = "center",
            {
                layout = wibox.layout.fixed.vertical,
                -- forced_height = 250,
                forced_width = 250,
                button_icon,
                button_text,
            }
        }        
    }
    
    local button_container = wibox.widget {
        widget = wibox.container.margin,
        left = 10,
        right = 10,
        button
    }
    
    button_container:connect_signal("mouse::enter", function()
        button_text.visible = true
        button.bg = utils.lighten(background_color, 0.075)
    end)
    
    button_container:connect_signal("mouse::leave", function() 
        button_text.visible = false
        button.bg = background_color
    end)
    return button_container
end

local function make_powermenu(s)
    local width = 1000
    local height = 250
    local y = (s.workarea.height / 2) - (height / 2) + 40
    local x = (s.workarea.width / 2) - (width  / 2) + 100
    
    local splash = wibox {
        screen = s,
        ontop = true,
        visible = false,
        type = "splash",
        bg = theme.colors.x4,
        height = height,
        width = width,
        x = x,
        y = y,
    }
    
    local buttons = wibox.layout.flex.horizontal()
    
    
    local poweroff = make_button(theme.icons.power, "Desligar", theme.colors.x1)
    local restart = make_button(theme.icons.restart, "Reiniciar", theme.colors.x0)
    local suspend = make_button(theme.icons.suspend, "Suspender", theme.colors.x5)
    local cancel = make_button(theme.icons.back, "Cancelar", theme.colors.x6)
    
    -- TODO: Put this commands someplace else (like a centralized config file)
    poweroff:buttons(gears.table.join(awful.button({}, 1, function() awful.spawn("poweroff") end)))
    restart:buttons(gears.table.join(awful.button({}, 1, function() awful.spawn("reboot") end)))
    suspend:buttons(gears.table.join(awful.button({}, 1, function() awful.spawn("systemctl suspend") end)))
    cancel:buttons(gears.table.join(awful.button({}, 1, function() splash.visible = false end)))
    
    buttons:add(poweroff)
    buttons:add(restart)
    buttons:add(suspend)
    buttons:add(cancel)
    
    
    splash:setup {
        widget = wibox.container.margin,
        top = 20,
        bottom = 20,
        left = 10,
        right = 10,
        buttons
    }
    
    _G.root.elements.powermenu = _G.root.elements.powermenu or {}
    _G.root.elements.powermenu[s.index] = splash
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not _G.root.elements.powermenu or not _G.root.elements.powermenu[s.index] then make_powermenu(s) end
    end)
end