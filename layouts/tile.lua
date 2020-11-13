local utils = require("utils");
local gears = require("gears");


local tile = {};

tile.name = "tile";

local function do_tile(p)
    local cls = p.clients;
    --    utils.obj_debug(p);
    
    if _G.preselect.widget then
        
    end
    print(gears.debug.dump_return(p))
    for k, c in ipairs(cls) do
        -- utils.xmessage(c.name);
        local g = {}
        -- If there is only one client in the screen - take the whole screen
        if #cls == 1 then
            g = {
                x = p.workarea.x,
                y = p.workarea.y,
                width = p.workarea.width,
                height = p.workarea.height,
            }
        else
            g = {
                x = _G.clients[c].x,
                y = _G.clients[c].y,
                width = _G.clients[c].width,
                height = _G.clients[c].height,
            }
        end
        
        p.geometries[c] = g;
    end
end

function tile.arrange(p)
    do_tile(p);
end

return tile;
