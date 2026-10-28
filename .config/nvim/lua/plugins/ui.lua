return {
	{
		'nvim-lualine/lualine.nvim',
    	dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("lualine").setup({
				options = { theme = "dracula" }
			})
		end,
	},
	{
	  "NvChad/nvim-colorizer.lua",
	  config = function()
	    require("colorizer").setup({
	      user_default_options = {
	        css = true,          -- Habilita en archivos CSS
	        mode = "background",  -- Muestra un cuadro de color al lado
	      }
	    })
	  end
	}
}
