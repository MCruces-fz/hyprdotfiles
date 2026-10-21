
-- ~/.config/hypr/modules/notes/editor.lua

local Config = require("modules.notes.config")
local FS = require("modules.notes.filesystem")

local Editor = {}

local function normalize_name(name)
    if type(name) ~= "string" or name == "" then
        return nil, "El nombre de la nota está vacío"
    end

    -- No permitir rutas ni nombres especiales.
    if name == "."
        or name == ".."
        or name:find("/", 1, true)
        or name:find("\\", 1, true)
        or name:find("%z")
    then
        return nil, "El título no puede contener rutas"
    end

    -- Mantener el comportamiento del script original:
    -- si no contiene un punto, añadir .md.
    if not name:find(".", 1, true) then
        name = name .. ".md"
    end

    return name
end

function Editor.open(name)
    local normalized, err = normalize_name(name)

    if not normalized then
        io.stderr:write(err .. "\n")
        return false
    end

    FS.ensure_directory()

    local path = FS.path(normalized)
    local command = Config.editor .. " " .. FS.shell_quote(path)

    local ok = os.execute(command)

    if ok ~= true and ok ~= 0 then
        io.stderr:write("No se pudo abrir la nota: " .. normalized .. "\n")
        return false
    end

    return true
end

return Editor
