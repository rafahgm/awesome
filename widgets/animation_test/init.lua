local awful = require('awful');
local wibox = require('wibox');

local function make(s)
  local animated_wibox = wibox {
    screen = s,
    ontop = true,
    visible = false,
    type = 'splash',
    width = 300,
    height = 300,
    x = 0,
    y = 0,
    bg = "#FFFFFF70",
  }

  animated_wibox:setup {
    layout = wibox.layout.fixed.horizontal,
    {
      widget = wibox.widget.textbox,
      text = "ANIMATIONS"
    }
  }
 
  _G.root.elements.animated_box = animated_wibox;
  return animated_wibox
end

return function()
  awful.screen.connect_for_each_screen(function(s)
    make(s);
  end)
end