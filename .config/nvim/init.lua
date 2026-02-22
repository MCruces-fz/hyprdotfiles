-- Set mapleader BEFORE anything else
vim.g.mapleader = " "
vim.g.maplocaleader = ","


-- Load CORE config -> nvim/lua/config
require("config")

-- Load plugins -> nvim/lua/config/lazy.lua
require("config.lazy")


-- NOTE: All this goes on modules:
-- * treesitter setup
-- * lualine setup
-- * logic
-- * direct bootstrap
