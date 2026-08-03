local Config = {}

Config.notes_dir = os.getenv("HOME").."documents/notes"

Config.window = {
	class = "quick_note",

	kitty_args = table.concat({
		"--class quick_note",
		"--override remember_window_size=no",
		"--override initial_window_width=75c",
		"--override initial_window_height=25c",
	}, " "),
}

Config.editor = "nvim"

return Config
