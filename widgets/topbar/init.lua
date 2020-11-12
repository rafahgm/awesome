local launcher = require("widgets.topbar.launcher");
local status = require("widgets.topbar.status");
local datetime = require("widgets.topbar.datetime");
local taglist = require("widgets.topbar.taglist");
local powerbutton = require("widgets.topbar.powerbutton");

local awful = require("awful");

return function()
    awful.screen.connect_for_each_screen(function(s)
      if not _G.root.elements.utilities or not _G.root.elements.utilities[s.index] then status(s) end
      if not _G.root.elements.date or not _G.root.elements.date[s.index] then datetime(s) end
      if not _G.root.elements.power or not _G.root.elements.power[s.index] then powerbutton(s) end
      if not _G.root.elements.taglist or not _G.root.elements.taglist[s.index] then taglist(s) end
    end)
  end