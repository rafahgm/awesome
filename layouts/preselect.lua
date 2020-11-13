local preselect = {};

local wibox = require("wibox");
local awful = require("awful");
local utils = require("utils");

_G.preselect = {
    tag = "",
    widget = nil,
    geo = {},
    client = nil,
    activated = false,
}

_G.clients = {};


_G.screen.connect_signal("tag::history::update", function(s)
    if _G.preselect.widget then 
        if s.selected_tag == _G.preselect.tag and _G.preselect.activated then
            _G.preselect.widget.visible = true;
        else
            _G.preselect.widget.visible = false;
        end
    end
    -- if preselect.widget then
    --     if not preselect.tag == s.selected_tag then
    --         utils.xmessage("ANOTHER TAG");
    --         preselect.widget.visible = false;
    --     end
    -- end
end)

_G.client.connect_signal("manage", function(c)
    -- if a new client appears when there is a preselect active
    if _G.preselect.activated then
        _G.clients[c] = {
            width = _G.preselect.geo.width,
            height = _G.preselect.geo.height,
            x = _G.preselect.geo.x,
            y = _G.preselect.geo.y,
        }

        _G.preselect.client:relative_move(
            0,
            _G.preselect.geo.height + 5,
            0,
            -_G.preselect.geo.height
        );

        _G.clients[_G.preselect.client] = {
            width = _G.preselect.client.width,
            height = _G.preselect.client.height,
            x = _G.preselect.client.x,
            y = _G.preselect.client.y,
        }
        
        -- _G.preselect.widget.visible = false;
        _G.preselect.activated = false;
    end
end)

preselect.add_preselect = function(c)
    -- Collect information from the client
    _G.preselect.tag = c.first_tag;
    _G.preselect.geo = {x = c.x, y = c.y, width = c.width };
    _G.preselect.geo.height = c.height / 2;
    _G.preselect.client = c;
    _G.preselect.activated = true;
    
    local widget = wibox {
        screen = c.screen,
        ontop = true,
        visible = true,
        bg = "#FFFFFF90",
        height = c.height / 2,
        width = c.width + 6,
        x = c.x,
        y = c.y,
    }
    
    widget:setup {
        widget = wibox.container.margin,
        top = 20,
        bottom = 20,
        left = 10,
        right = 10,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.widget.textbox,
                text = "PRESELECT",
            }
            
        }
    }
    _G.preselect.widget = widget;
end

return preselect;
