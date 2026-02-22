return {
	{
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		lazy = false,
  		build = ':TSUpdate',
		-- event = { "BufReadPost", "BufNewFile" },

		-- config = function()
		-- 	require("nvim-treesitter.config").setup({
		-- 		ensure_installed = { "python", "rust" },
		-- 		highlight = {
		-- 			enable = true,
		-- 			additional_vim_regex_highlighting = false,
		-- 		},
		-- 		indent = { enable = true },
		-- 	})
		-- end,

		config = function()
			local treesitter = require("nvim-treesitter")
			-- treesitter.setup { install_dir = vim.fn.stdpath('data') .. '/site' }
			treesitter.install { "python", "rust" }
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {"python", "rust"},
				callback = function()
					-- syntax highlighting, provided by Neovim
					vim.treesitter.start()
					-- folds, provided by Neovim (I don't like folds)
					-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					-- vim.wo.foldmethod = 'expr'
					-- indentation, provided by nvim-treesitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
