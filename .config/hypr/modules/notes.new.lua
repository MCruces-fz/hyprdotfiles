
-- ~/.config/hypr/modules/notes.lua

local NewNotes = {}

local HOME = assert(os.getenv("HOME"), "HOME no está definido")

local Config = require("modules.notes.config")

local function toggle_focus()
    hl.dispatch(hl.dsp.workspace.toggle_special(Config.special_workspace))

    local special = hl.get_active_special_workspace()

    if special then
        hl.dispatch(hl.dsp.focus({
            window = "class:" .. Config.kitty_class,
        }))
    end
end

function NewNotes.toggle_notes()
    local window_exists = false

    for _, win in ipairs(hl.get_windows()) do
        if win.class == Config.kitty_class then
            window_exists = true
            break
        end
    end

    if not window_exists then
        local args = {}

        for _, arg in ipairs(Config.window.kitty_args) do
            args[#args + 1] = arg
        end

        args[#args + 1] = "-e"
        args[#args + 1] = "lua"
        args[#args + 1] = HOME .. "/.config/hypr/modules/notes/init.lua"

        -- Citar los argumentos para no romper las rutas con espacios.
        local command_parts = {}

        for _, arg in ipairs(args) do
            command_parts[#command_parts + 1] =
                "'" .. tostring(arg):gsub("'", "'\\''") .. "'"
        end

        local rules = "[workspace special:" ..
            Config.special_workspace .. " silent;float;center]"

        hl.exec_cmd(
            rules .. " "
            .. Config.kitty
            .. " "
            .. table.concat(command_parts, " ")
        )
    end

    hl.timer(toggle_focus, {
        timeout = 150,
        type = "oneshot",
    })
end

return NewNotes
