-- Keymaps
local keymap = vim.keymap  -- alias

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

------------------------------------
-- map Ctrl+C / Ctrl+V inside Vim --
------------------------------------
-- needed this option in lua/config/options.lua -> vim.opt.clipboard={"unnamedplus"}

-- Visual mode: copy selection to CLIPBOARD with Ctrl+C
keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
-- Insert mode: paste from CLIPBOARD with Ctrl+V
keymap.set("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })


