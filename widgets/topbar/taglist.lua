local awful = require("awful");
local wibox = require("wibox");
local theme = require("beautiful");
local gears = require("gears");
local utils = require("utils");

return function(s)
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
    awful.button({}, 1, function(t) t:view_only() end))
    
    local tags = awful.widget.taglist{
      screen = s,
      filter = awful.widget.taglist.filter.all,
      layout = wibox.layout.fixed.horizontal,
      buttons = taglist_buttons,
      widget_template = {
        widget = wibox.widget.textbox,
        font = theme.font,
        forced_height = theme.topbar.h,
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