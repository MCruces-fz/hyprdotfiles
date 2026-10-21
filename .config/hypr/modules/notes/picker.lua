
-- ~/.config/hypr/modules/notes/picker.lua

local Config = require("modules.notes.config")
local FS = require("modules.notes.filesystem")

local Picker = {}

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end

    local content = file:read("*a")
    file:close()

    return content
end

local function write_file(path, content)
    local file, err = io.open(path, "w")
    if not file then
        return false, err
    end

    file:write(content)
    file:close()

    return true
end

local function notes_input()
    local lines = {}

    for _, note in ipairs(FS.list_notes()) do
        lines[#lines + 1] = note.name
    end

    if #lines == 0 then
        return ""
    end

    return table.concat(lines, "\n") .. "\n"
end

local function last_line(output)
    if not output or output == "" then
        return ""
    end

    output = output:gsub("\r\n", "\n")
    output = output:gsub("\n+$", "")

    return output:match("([^\n]*)$") or ""
end

function Picker.run()
    FS.ensure_directory()

    local input_path = os.tmpname()
    local output_path = os.tmpname()

    local ok, err = write_file(input_path, notes_input())
    if not ok then
        os.remove(input_path)
        os.remove(output_path)
        error("No se pudo preparar el selector: " .. tostring(err))
    end

    local quote = FS.shell_quote
    local notes_dir = quote(Config.notes_dir)

    -- Los nombres que fzf inserta en {} se escapan para el shell
    -- por fzf. El directorio se cita por separado.
    local preview = "cat -- " .. notes_dir .. "/{}"
    local reload = "ls -1t -- " .. notes_dir

    local bind = table.concat({
        "ctrl-d:execute-silent(rm -f -- "
            .. notes_dir .. "/{})+reload(" .. reload .. ")",
    })

    local command = table.concat({
        quote(Config.picker),
        "--height=100%",
        "--layout=reverse",
        "--border",
        "--print-query",
        "--header=" .. quote(Config.fzf.header),
        "--prompt=" .. quote("> "),
        "--preview=" .. quote(preview),
        "--bind=" .. quote(bind),
        "--preview-window=right:60%:wrap",
        "< " .. quote(input_path),
        "> " .. quote(output_path),
    }, " ")

    -- fzf utiliza el terminal interactivo para la interfaz.
    local status = os.execute(command)

    local output = read_file(output_path)

    os.remove(input_path)
    os.remove(output_path)

    -- Cancelar con Esc no abre ni crea ninguna nota.
    if status ~= true and status ~= 0 then
        return nil
    end

    local selection = last_line(output)

    if selection == "" then
        return nil
    end

    return selection
end

return Picker
