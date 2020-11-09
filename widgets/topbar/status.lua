local theme = require("beautiful");
local wibox = require("wibox");
local utils = require("utils");


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

return function(s)
    local width = 500
    
    local utilities = wibox {
      screen = s,
      width = width,
      visible = true,
      type = "utility",
      bg = "#FFFFFF70",
      height = theme.topbar.h,
      valign = "center",
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
      
      local battery_container = wibox.widget {
        layout = wibox.container.margin,
        left = 10,
        right = 10,
        battery_widget
      }
      _G.root.elements.battery_icons = _G.root.elements.battery_icons or {}
      _G.root.elements.battery_icons[s.index] = battery_widget
      layout:add(battery_container)
    end
    
    if theme.topbar.utilities.volume then 
      local volume_widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
          id = "volume_icon",
          widget = wibox.widget.textbox,
          text = theme.icons.volume.high,
          font = theme.fonts.im,
        },
        {
          id = "volume_text",
          widget = wibox.widget.textbox,
          text = " 100%",
          font = theme.font,
        }
      }
      
      local volume_container = wibox.widget {
        layout = wibox.container.margin,
        left = 10,
        right = 10,
        volume_widget
      }
      _G.root.elements.volume_widget = _G.root.elements.volume_widget or {}
      _G.root.elements.volume_widget[s.index] = volume_widget
      layout:add(volume_container)
    end
    
    utilities:struts{top = theme.global.m}
    utilities.x = ((s.workarea.width / 2) - (width / 2))
    utilities.y = theme.global.m
    
    utilities:setup {
      layout = wibox.container.place,
      valign = "center",
      layout,
    }
  end
  