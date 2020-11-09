local wibox = require("wibox");
local gears = require("gears");
local theme = require("beautiful");
local awful = require("awful");

return function(s)
    local launcher = wibox({
      screen = s,
      type = 'menu',
      visible = true,
      width = theme.topbar.w,
      height = theme.topbar.h,
    });
    
    launcher:setup {
      layout = wibox.container.margin,
      forced_width = theme.topbar.w,
      forced_height = theme.topbar.h,
      {
        layout = wibox.container.background,
        shape = gears.shape.rectangle,
        bg = theme.colors.x4,
        fg = theme.colors.w,
        {
          layout = wibox.container.place,
          {
            widget = wibox.widget.textbox,
            text = theme.icons.arch,
            font = theme.fonts.im,
          }
        }
      }
    }
    
    launcher:struts({ top = theme.topbar.h + theme.global.m });
    launcher.x = s.workarea.x + theme.global.m;
    launcher.y = theme.global.m;
    launcher:buttons(gears.table.join(
    awful.button({}, 1, function() 
      awful.spawn("rofi -show drun");
    end)
  ));
  _G.root.elements.launcher = _G.root.elements.launcher or {};
  _G.root.elements.launcher[s.index] = launcher;
  end