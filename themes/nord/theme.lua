local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears');
local theme = {};

local theme_dir = gears.filesystem.get_configuration_dir().."themes/nord/";
local wallpapers_dir = theme_dir .. "wallpapers/";

theme.useless_gap = dpi(5);

theme.colors = {
  c0 = "#2e3440",
  c1 = "#3b4252",
  c2 = "#434c5e",
  c3 = "#4c566a",
  c4 = "#d8dee9",
  c5 = "#e5e9f0",
  c6 = "#eceff4",
  c7 = "#8fbcbb",
  c8 = "#88c0d0",
  c9 = "#81a1c1",
  c10 = "#5e81ac",
  c11 = "#bf616a",
  c12 = "#d08770",
  c13 = "#ebcb8b",
  c14 = "#a3be8c",
  c15 = "#b48ead",
}

theme.fonts = {
  inter = {
    small = {
      bold = "Inter Bold 9",
      regular ="Inter Regular 9"
    },
    medium = {
      bold = "Inter Bold 12",
      regular ="Inter Regular 12"
    },
    large = {
      bold = "Inter Bold 16",
      regular ="Inter Regular 16"
    }
  },
  fontawesome = {
    solid = {
      small = "Font Awesome 5 Free Solid 9",
      medium = "Font Awesome 5 Free Solid 12"
    },
    regular = {
      small = "Font Awesome 5 Free Regular 9",
      medium = "Font Awesome 5 Free Regular 12"
    }
   
  }
}

theme.font = theme.fonts.inter.medium.regular;

theme.icons = {
  fontawesome = {
    bell = "",
    cricle = "",
    battery_charging = "",
    power = "",
    wifi = "",
    volume = {
      low = "",
      medium = "",
      max = "",
      mute = ""
    }
  }
}

theme.wallpapers = {
  wallpapers_dir.."mountains.png",
  wallpapers_dir.."mountain_bright.png",
}

return theme;