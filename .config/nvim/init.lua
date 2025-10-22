-- Basic options
local opt = vim.opt  -- alias 

opt.tabstop = 4 -- Always 8 (see :g tabstop)
opt.softtabstop = 4
opt.shiftwidth = 4

-- Enable numbering
opt.number = true
opt.relativenumber = true

-- Enable syntax highlighting
vim.cmd("syntax on")

-- Use 256 colors if supported
--opt.t_Co = 256

-- Allow Vim to access the system clipboard
-- This makes Vim use both the CLIPBOARD (+) and PRIMARY (*) registers
opt.clipboard = { "unnamedplus", "unnamed" }

-- Now:
-- 	y, d, p will work with the system clipboard (CLIPBOARD)
-- 	The PRIMARY selection (*) can still be accessed explicitly with "*y, "*p
--
-- Example:
-- 	"+yy -> yank current line to CLIPBOARD (Ctrl+C / Ctrl+V buffer) 
-- 	"*yy -> yank current line to PRIMARY (mouse middle-click buffer) 
-- 	"+p -> paste from CLIPBOARD 
-- 	"*p -> paste from PRIMARY


-- Keymaps
local keymap = vim.keymap  -- alias

-- Optional: map Ctrl+C / Ctrl+V inside Vim

-- Visual mode: copy selection to CLIPBOARD with Ctrl+C
keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Insert mode: paste from CLIPBOARD with Ctrl+V
keymap.set("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })


-- Bootstrap lazy.nvim: the next 14 lines automatically sets up the lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


require("options")
require("lazy").setup("plugins")
require("keymaps")
require("autocmds")
require("lualine").setup {
	options = {
		theme = "dracula"
	}
}

