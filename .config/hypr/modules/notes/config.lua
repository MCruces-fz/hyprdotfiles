
-- ~/.config/hypr/modules/notes/config.lua

local HOME = assert(os.getenv("HOME"), "HOME no está definido")

local Config = {
    home = HOME,
    -- notes_dir = HOME .. "/documents/notes",
    notes_dir = HOME .. "/documents/linux_annots",

    kitty = "kitty",
    kitty_class = "quick_note",
    special_workspace = "notes",

    editor = "nvim",
    picker = "fzf",

    fzf = {
        header = "🛒 Ctrl+D: Drop note | Enter: Add/Edit",
        placeholder = "Escribe título o selecciona nota...",
    },

    window = {
        kitty_args = {
            "--class", "quick_note",
            "--override", "remember_window_size=no",
            "--override", "initial_window_width=100c",
            "--override", "initial_window_height=25c",
        },
    },
}

return Config
