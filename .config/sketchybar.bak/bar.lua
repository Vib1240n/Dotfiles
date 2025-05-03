local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "true",
  height = 50,
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
  blur_radius = 10,
  margin = 500,
})
