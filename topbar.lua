local wibox = require("wibox")
local theme = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local utils = require("utils")

local root = {
  elements = {}
}

local function make_launcher(s)
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

local function make_date(s) 
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

local function make_power(s)
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
    if root.elements.powermenu.show then root.elements.powermenu.show() end
  end)
))

root.elements.power = root.elements.power or {};
root.elements.power[s.index] = power;
end

local function make_taglist(s)
  local all_tags = awful.screen.focused().tags
  
  local function update_taglist(self, tag, index)
    local name = all_tags[index].name
    name = utils.pads_spaces_both(name, 3)
    
    if tag.selected then
      -- Seletcted Tag
      self.markup = utils.colorize_text(name, "#000000", "#FEFEFEFF")
    elseif tag.urgent then
      -- Urgent tag
      self.markup = utils.colorize_text(name, "#FF0000", "#FEFEFE50")
    elseif #tag:clients() > 0 then
      -- If unselected tag have clients
      self.markup = utils.colorize_text(name, "#FFFFFF", "#FEFEFE90")
    else
      -- Rest of the tags (unseletcted and empty)
      self.markup = utils.colorize_text(name, "#FFFFFF", "#FEFEFE40")
    end
  end
  
  local tags = awful.widget.taglist{
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = wibox.layout.fixed.horizontal,
    widget_template = {
      widget = wibox.widget.textbox,
      font = theme.font,
      height = theme.topbar.h,
      create_callback = function(self, tag, index, _)
        self.align = "center"
        self.valign = "center"
        update_taglist(self, tag, index)
      end,
      update_callback = function(self, tag, index, _)
        update_taglist(self, tag, index)
      end
    },
  }
  
  local taglist = wibox({
    screen = s,
    type = "menu",
    visible = true,
    height = theme.topbar.h,
    width = 360,
    bg = "#FFFFFF00",
    x = s.workarea.x + theme.global.m + theme.global.m + theme.topbar.w,
    y = theme.global.m,
    struts = {top = theme.global.m},
  })
  
  taglist:setup{
    layout = wibox.container.place,
    valign = "center",
    tags
  }
  
  root.elements.taglist = root.elements.taglist or {}
  root.elements.taglist[s.index] = taglist
end

return function()
  awful.screen.connect_for_each_screen(function(s)
    if not root.elements.launcher or not root.elements.launcher[s.index] then make_launcher(s) end
    if not root.elements.date or not root.elements.date[s.index] then make_date(s) end
    if not root.elements.power or not root.elements.power[s.index] then make_power(s) end
    if not root.elements.taglist or not root.elements.taglist[s.index] then make_taglist(s) end
  end)
end