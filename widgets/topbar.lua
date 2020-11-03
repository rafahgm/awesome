local wibox = require("wibox")
local theme = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local utils = require("utils")

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

_G.root.elements.launcher = _G.root.elements.launcher or {};
_G.root.elements.launcher[s.index] = launcher;
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
  
  _G.root.elements.date = _G.root.elements.date or {}
  _G.root.elements.date[s.index] = date
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
    if _G.root.elements.powermenu.show then _G.root.elements.powermenu.show() end
  end)
))

_G.root.elements.power = _G.root.elements.power or {};
_G.root.elements.power[s.index] = power;
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

  local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end)
  )
  
  local tags = awful.widget.taglist{
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = wibox.layout.fixed.horizontal,
    buttons = taglist_buttons,
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
    width = 362,
    bg = "#00FFFF00",
    x = s.workarea.x + theme.global.m + theme.global.m + theme.topbar.w,
    y = theme.global.m,
    struts = {top = theme.global.m},
  })
  
  taglist:setup{
    layout = wibox.container.place,
    valign = "center",
    tags
  }
  
  _G.root.elements.taglist = _G.root.elements.taglist or {}
  _G.root.elements.taglist[s.index] = taglist
end

local function make_icon(i, f, b) 
  local icon = wibox.widget.textbox()
  icon.forced_width = theme.topbar.w
  icon.font = theme.fonts.im
  icon.markup = utils.colorize_text(i, f, b)

  local container = wibox.widget {
    layout = wibox.container.background,
  }

  icon.update = function(t,c) icon.markup = "<span color='"..c.."'>"..t.."</span>" end
  return icon
end

local function make_utilities(s)
  local width = theme.global.m + 100
  for _,v in pairs(theme.topbar.utilities) do
    if v then width = width + theme.topbar.w end
  end

  local utilities = wibox {
    screen = s,
    width = width,
    visible = true,
    type = "utility",
    bg = "#FFFFFF70",
    height = theme.topbar.h,
  }

  local layout = wibox.layout.fixed.horizontal();

  if theme.topbar.utilities.wifi then
    _G.root.elements.wifi_icons = _G.root.elements.wifi_icons or {}
    _G.root.elements.wifi_icons[s.index] = make_icon(theme.icons.wifi, theme.colors.w, theme.colors.t)
    layout:add(_G.root.elements.wifi_icons[s.index])
  end
  
  if theme.topbar.utilities.battery then
    local battery_widget = wibox.widget {
      layout = wibox.layout.fixed.horizontal,
      {
        id = "battery_icon",
        widget = wibox.widget.textbox,
        text = theme.icons.battery.full,
        font = theme.fonts.im,
      },
      {
        id = "battery_text",
        widget = wibox.widget.textbox,
        text = "50%",
        font = theme.font,
      }
    }
    _G.root.elements.battery_icons = _G.root.elements.battery_icons or {}
    _G.root.elements.battery_icons[s.index] = battery_widget
    layout:add(_G.root.elements.battery_icons[s.index])
  end

  utilities:struts{top = theme.global.m}
  utilities.x = ((s.workarea.width / 2) - (width / 2))
  utilities.y = theme.global.m

  utilities:setup {
    layout = wibox.container.margin,
    right = theme.global.m,
    left = theme.global.m,
    layout
  }
end

return function()
  awful.screen.connect_for_each_screen(function(s)
    if not _G.root.elements.utilities or not _G._G.root.elements.utilities[s.index] then make_utilities(s) end
    if not _G.root.elements.launcher or not _G.root.elements.launcher[s.index] then make_launcher(s) end
    if not _G.root.elements.date or not _G.root.elements.date[s.index] then make_date(s) end
    if not _G.root.elements.power or not _G.root.elements.power[s.index] then make_power(s) end
    if not _G.root.elements.taglist or not _G.root.elements.taglist[s.index] then make_taglist(s) end
  end)
end