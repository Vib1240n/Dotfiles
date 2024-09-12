local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ { import = "bb8.plugins" }, { import = "bb8.plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
