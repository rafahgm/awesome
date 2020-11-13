local preselect = {};

local wibox = require("wibox");
local awful = require("awful");
local utils = require("utils");
local dpi = require("beautiful").xresources.apply_dpi

_G.presel = {
    tag = "",
    widget = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0,
    client = nil,
    activated = false,
    type = "",
}

_G.clients = {};


_G.screen.connect_signal("tag::history::update", function(s)
    if _G.presel.widget then
        if s.selected_tag == _G.presel.tag and _G.presel.activated then
            _G.presel.widget.visible = true;
        else
            _G.presel.widget.visible = false;
        end
    end
end)

_G.client.connect_signal("manage", function(c)
    -- if a new client appears when there is a preselect active
    if _G.presel.activated then
        _G.clients[c] = {
            width = _G.presel.width,
            height = _G.presel.height,
            x = _G.presel.x,
            y = _G.presel.y,
        }
        -- ? For some reason the client is shrinking beyond needed, maybe 
        -- ? try to add useless_gap to resize
        if _G.presel.type == "horizontal" then
            -- _G.presel.client:relative_move(
            -- 0,
            -- _G.presel.height,
            -- 0,
            -- - _G.presel.height
            -- );
            _G.clients[_G.presel.client] = {
                width = _G.presel.client.width,
                height = _G.presel.client.height - _G.presel.height,
                x = _G.presel.client.x,
                y = awful.screen.focused().workarea.y + _G.presel.height + dpi(10),
            }
        elseif _G.presel.type == "vertical" then
            _G.presel.client:relative_move(
            0,
            0,
            _G.presel.width,
            0
        );
    end
    
    -- _G.clients[_G.presel.client] = {
    --     width = _G.presel.client.width,
    --     height = _G.presel.client.height,
    --     x = _G.presel.client.x,
    --     y = _G.presel.client.y,
    -- }
    -- Preselect has benn consumed make it go away
    _G.presel.widget.visible = false;
    _G.presel.activated = false;
end
end)


local ver_presel = function(c)
    -- Collect information from the client
    _G.presel.width = c.width / 2;
    _G.presel.height = c.height;
    _G.presel.x = c.x + c.width / 2;
    _G.presel.y = c.y;
end

local hor_presel = function(c)
    -- Collect information from the client
    _G.presel.width = c.width;
    _G.presel.height = c.height / 2;
    _G.presel.x = c.x;
    _G.presel.y = c.y;
    
end

preselect.presel = function(c, type)
    _G.presel.client = c;
    _G.presel.tag = c.first_tag;
    _G.presel.type = type;
    _G.presel.activated = true;
    
    if type == "vertical" then
        ver_presel(c);
    elseif type == "horizontal" then
        hor_presel(c);
    end
    
    if not _G.presel.widget then
        local widget = wibox {
            screen = c.screen,
            ontop = true,
            visible = true,
            bg = "#FFFFFF50",
            height = _G.presel.height,
            width = _G.presel.width,
            x = _G.presel.x,
            y = _G.presel.y,
        }
        _G.presel.widget = widget;
    else
        _G.presel.widget.height = _G.presel.height;
        _G.presel.widget.width = _G.presel.width;
        _G.presel.widget.x = _G.presel.x;
        _G.presel.widget.y = _G.presel.y;
        _G.presel.widget.visible = true;
    end
end

return preselect;
