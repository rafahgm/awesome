local tween = require('tween');
local glib = require('lgi').GLib
local animation = {}

local timeconversion = {
  second_to_micro = function(sec) return sec * 1000000 end,
}

animation.start_animation = function(subject) 
  local last_elapsed = glib.get_monotonic_time();
  local tween_obj = tween.new(timeconversion.second_to_micro(3), subject, {x = 100}, 'linear');

  local timer = glib.timeout_add(glib.PRIORITY_DEFAULT, 16.7, function()
    local time = glib.get_monotonic_time()

    local delta_time = time - last_elapsed;
    last_elapsed = time

    local completed = tween_obj:update(delta_time);

    if completed then
      return false
    end
    return true
  end)
end

return animation