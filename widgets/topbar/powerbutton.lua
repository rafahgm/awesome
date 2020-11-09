local wibox = require("wibox");
local theme = require("beautiful");
local gears = require("gears");
local awful = require("awful");

return function(s)
    local power = wibox({
        screen = s,
        type = "menu",
        visible = true,
        height = theme.topbar.h,
        width = theme.topbar.w
    })
    
    power:setup {
        layout = wibox.container.margin,
        forced_width = theme.topbar.w,
        forced_height = theme.topbar.h,
        {
            layout = wibox.container.background,
            bg = theme.colors.x9,
            fg = theme.colors.w,
            {
                layout = wibox.container.place,
                {
                    widget = wibox.widget.textbox,
                    text = theme.icons.power,
                    font = theme.fonts.im,
                }
            }
        }
    }
    
    power:struts({top = theme.topbar.h + theme.global.m});
    power.x = s.workarea.width - (theme.topbar.w + theme.global.m);
    power.y = theme.global.m;
    
    power:buttons(gears.table.join(
    awful.button({}, 1, function()
        _G.root.elements.powermenu[s.index].visible = true
    end)
))
_G.root.elements.power = _G.root.elements.power or {};
_G.root.elements.power[s.index] = power;
end