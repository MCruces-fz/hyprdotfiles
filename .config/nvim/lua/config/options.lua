-- Basic options
local opt = vim.opt  -- alias 

opt.tabstop = 4 -- Always 8 (see :g tabstop)
opt.softtabstop = 4
opt.shiftwidth = 4

-- Enable numbering
opt.number = true
opt.relativenumber = true

-- Use 256 colors if supported
--opt.t_Co = 256

-- Allow Vim to access the system clipboard
-- This makes Vim use both the CLIPBOARD (+) and PRIMARY (*) registers
opt.clipboard = { "unnamedplus", "unnamed" }
-- Necesito unnamed también o solamente unnamedplus??

-- Now:
-- 	y, d, p will work with the system clipboard (CLIPBOARD)
-- 	The PRIMARY selection (*) can still be accessed explicitly with "*y, "*p
--
-- Example:
-- 	"+yy -> yank current line to CLIPBOARD (Ctrl+C / Ctrl+V buffer) 
-- 	"*yy -> yank current line to PRIMARY (mouse middle-click buffer) 
-- 	"+p -> paste from CLIPBOARD 
-- 	"*p -> paste from PRIMARY

