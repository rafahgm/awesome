local wibox = require('wibox');
local dpi = require('beautiful').xresources.apply_dpi;
local gears = require('gears');
local utils = require('utils');
local theme = require('themes.transparent.definitions');

local function create_notification(app_name, title, body)
  local notification_header = wibox.widget {
      widget = wibox.container.margin,
      left = dpi(10),
      right = dpi(10),
      {
          widget = wibox.container.background,
          bg = "#FEFEFE99",
          shape = function(cr, width, height)
              gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, dpi(10))
          end,
          {
              widget = wibox.container.margin,
              left = dpi(10), right = dpi(10), top = dpi(5), bottom = dpi(5),
              {
                  layout = wibox.layout.align.horizontal,
                  {
                      layout = wibox.layout.fixed.horizontal,
                      {
                          widget = wibox.widget.textbox,
                          font = theme.fonts.im,
                          markup = utils.colorize_text("󰇮  ", "#242424")
                      },
                      {
                          widget = wibox.widget.textbox,
                          font = theme.fonts.rsb,
                          markup = utils.colorize_text(app_name, "#242424")
                      },
                  },
                  nil,
                  {
                      widget = wibox.widget.textbox,
                      font = theme.fonts.rsb,
                      markup = utils.colorize_text("24m atrás", "#242424")
                  }
              }
          }
      }
  }
  
  local notification_body = wibox.widget {
      widget = wibox.container.margin,
      left = dpi(10),
      right = dpi(10),
      {
          widget = wibox.container.background,
          bg = "#F0F0F080",
          shape = function(cr, width, height)
              gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, dpi(10))
          end,
          {
              widget = wibox.container.margin,
              margins = dpi(10),
              {
                  layout = wibox.layout.fixed.vertical,
                  spacing = dpi(10),
                  {
                      widget = wibox.widget.textbox,
                      font = theme.fonts.rrb,
                      markup = utils.colorize_text(title, "#242424")
                  }, 
                  {
                      widget = wibox.widget.textbox,
                      font = theme.font,
                      markup = utils.colorize_text(body, "#242424")
                  }
                  
              }
          }
      }
  }
  
  local notification = wibox.widget {
      layout = wibox.layout.fixed.vertical,
      notification_header,
      notification_body
  }
  
  return notification
end

return create_notification