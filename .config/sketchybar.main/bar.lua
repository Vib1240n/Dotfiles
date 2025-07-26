local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "true",
  height = 40,
  color = colors.bar.white,
  padding_right = 2,
  padding_left = 2,
  blur_radius = 30,
  margin = 12,
  y_offset = 0,
  corner_radius = 16,
})
