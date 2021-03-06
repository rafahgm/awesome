local awful = require("awful");
local wibox = require("wibox");
local theme = require("themes.transparent.definitions");
local gears = require("gears");
local utils = require("utils");
local nord = require('theme_engine');

return function(s)
    local all_tags = awful.screen.focused().tags;
    
    local function update_taglist(self, tag, index)
      -- local name = all_tags[index].name;
      local text_widget = self:get_children()[1]:get_children()[1];
      -- text_widget:set_text(name);
      
      if tag.selected then
        -- Seletcted Tag
        self.bg = nord.colors.c4;
        text_widget:set_font(nord.fonts.fontawesome.solid.medium)
        text_widget:set_markup(utils.colorize_text(nord.icons.fontawesome.cricle, nord.colors.c0));
      elseif tag.urgent then
        -- Urgent tag
        self.bg = nord.colors.c11;
      elseif #tag:clients() > 0 then
        -- If unselected tag have clients
        self.bg = nil;
        text_widget:set_font(nord.fonts.fontawesome.solid.medium)
        text_widget:set_markup(utils.colorize_text(nord.icons.fontawesome.cricle, nord.colors.c4));
      else
        -- Empty and unselected
        self.bg = nil;
        text_widget:set_font(nord.fonts.fontawesome.regular.medium)
        text_widget:set_markup(utils.colorize_text(nord.icons.fontawesome.cricle, nord.colors.c4));
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
        widget = wibox.container.background,
        forced_height = theme.topbar.h,
        forced_width = 40,
        
        {
          layout = wibox.container.place,
          halign = "center",
          {
            widget = wibox.widget.textbox,
            text = "w",
          }
        },
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

    return tags
  end