local wibox = require("wibox");
local theme = require("beautiful");

return function(s) 
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
    
    _G.root.elements.date = _G.root.elements.date or {}
    _G.root.elements.date[s.index] = date
  end