return {
	{
		"folke/tokyonight.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"sainnhe/gruvbox-material",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("kanagawa-wave") -- purpled dark
			-- vim.cmd.colorscheme("kanagawa-dragon") -- blackened dark
			-- vim.cmd.colorscheme("kanagawa-lotus") -- light
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-frappe") -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
		end,
	},
}
