return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  blue = 0xff76cce0,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  transparent = 0x00000000,
  teal = 0xFF51E1E9,
  purple = 0xffc952ed,

  bar = {
    bg = 0xE7000000, --dark
    -- bg = 0x18FFFFFF,
    bg_dark = 0xE7000000,
    icon_dark = 0xff181819,
    icon_light = 0xFFe2e2e3,
    label_dark = 0xff181919,
    label_light = 0xffe2e2e3,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490,
  },
  bg1 = 0xff363944,
  bg2 = 0xff414550,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then
      return color
    end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
