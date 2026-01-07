-- mini.files - floating file explorer with miller columns
return {
  "echasnovski/mini.files",
  version = false,
  keys = {
    {
      "<leader>e",
      function()
        local MiniFiles = require("mini.files")
        if not MiniFiles.close() then
          MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
        end
      end,
      desc = "Toggle mini.files (current file)",
    },
    {
      "<leader>E",
      function()
        local MiniFiles = require("mini.files")
        if not MiniFiles.close() then
          MiniFiles.open(vim.fn.getcwd(), true)
        end
      end,
      desc = "Toggle mini.files (cwd)",
    },
  },
  opts = {
    mappings = {
      close = "q",
      go_in = "l",
      go_in_plus = "<CR>",
      go_out = "h",
      go_out_plus = "H",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },
    options = {
      permanent_delete = false,
      use_as_default_explorer = false,
    },
    windows = {
      preview = true,
      width_focus = 35,
      width_nofocus = 20,
      width_preview = 50,
    },
  },
  config = function(_, opts)
    local MiniFiles = require("mini.files")
    MiniFiles.setup(opts)

    -- Set cursorline on open (no winblend needed with Kitty color-match)
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowOpen",
      callback = function(args)
        local win_id = args.data.win_id
        vim.wo[win_id].cursorline = true
      end,
    })

    -- Custom highlight overrides for glassmorphic look
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowOpen",
      callback = function()
        vim.api.nvim_set_hl(0, "MiniFilesNormal", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "MiniFilesBorder", { link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "MiniFilesTitle", { link = "FloatTitle" })
      end,
    })
  end,
}
