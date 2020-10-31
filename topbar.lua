local wibox = require("wibox")
local theme = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local utils = require("utils")

root.elements = root.elements or {}

function make_launcher(s)
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
  
    root.elements.launcher = root.elements.launcher or {};
    root.elements.launcher[s.index] = launcher;
end

function make_date(s) 
    local date = wibox({
        screen = s,
        type = "dock",
        visible = true,
        bg = theme.colors.x4,
        fg = theme.colors.w,
        height = theme.topbar.h,
        width = theme.topbar.dw,
    });

    date:setup {
        layout = wibox.container.place,
        valign = "center",
        {
            widget = wibox.widget.textclock,
            font = theme.font,
            refresh = 60,
            format = theme.icons.date..' %a, %b %_d '..theme.icons.time..' %_I:%M %p',
        },
    };

    date.x = (s.workarea.width - theme.topbar.dw) - (theme.topbar.w + theme.global.m) - theme.global.m;
    date.y = theme.global.m;

    root.elements.date = root.elements.date or {}
    root.elements.date[s.index] = date
end

function make_power(s)
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
      shape = utils.rounded(8),
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
      if root.elements.powermenu.show then root.elements.powermenu.show() end
    end)
  ))

  root.elements.power = root.elements.power or {};
  root.elements.power[s.index] = power;
end

return function()
    awful.screen.connect_for_each_screen(function(s)
        if not root.elements.launcher or not root.elements.launcher[s.index] then make_launcher(s) end
        if not root.elements.date or not root.elements.date[s.index] then make_date(s) end
        if not root.elements.power or not root.elements.power[s.index] then make_power(s) end
    end)
end