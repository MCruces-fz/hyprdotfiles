local Notes = {}

local HOME = os.getenv("HOME")
local NOTES_DIR = HOME.."documents/notes"


local function ensure_notes_dir()
    os.execute("mkdir -p "..NOTES_DIR)
end


local function toggle_focus()
	hl.dispatch(hl.dsp.workspace.toggle_special("notes"))
	local special = hl.get_active_special_workspace()
	if special then
		hl.dispatch(hl.dsp.focus({ window = "class:quick_note" }))
	end
end

-- Función nativa y asíncrona para alternar tus notas
function Notes.toggle_notes()
    local window_exists = false
	local notes_window = nil

    -- 1. Buscamos de forma nativa en la lista de ventanas sin bloquear el sistema
    for _, win in ipairs(hl.get_windows()) do
        if win.class == "quick_note" then
            window_exists = true
			notes_window = win
			break
        end
    end

	if not window_exists then
		-- Si NO existe, lanzamos kitty asíncronamente con hl.exec_cmd
    	local target_script = HOME.."/.local/bin/my_notes.sh"
    	local rules = "[workspace special:notes silent;float;center]"
    	local kitty_args = "--class quick_note --override remember_window_size=no --override initial_window_width=100c --override initial_window_height=25c"

    	-- Ejecución asíncrona nativa
    	hl.exec_cmd(rules.." kitty ".. kitty_args.." -e ".. target_script)
	end

	hl.timer(toggle_focus, { timeout = 150, type = "oneshot"})
end

return Notes
