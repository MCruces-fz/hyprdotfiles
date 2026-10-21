
-- ~/.config/hypr/modules/notes/filesystem.lua

local lfs = require("lfs")
local Config = require("modules.notes.config")

local FS = {}

local function shell_quote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

FS.shell_quote = shell_quote

function FS.path(name)
    return Config.notes_dir .. "/" .. name
end

function FS.ensure_directory()
    local attr = lfs.attributes(Config.notes_dir)

    if attr then
        assert(attr.mode == "directory",
            "La ruta de notas existe, pero no es un directorio: "
            .. Config.notes_dir)
        return true
    end

    -- Crear también directorios padre si faltan.
    local command = "mkdir -p -- " .. shell_quote(Config.notes_dir)
    local ok = os.execute(command)

    if ok ~= true and ok ~= 0 then
        error("No se pudo crear el directorio de notas: "
            .. Config.notes_dir)
    end

    return true
end

function FS.exists(name)
    return lfs.attributes(FS.path(name)) ~= nil
end

function FS.list_notes()
    FS.ensure_directory()

    local notes = {}

    for name in lfs.dir(Config.notes_dir) do
        if name ~= "." and name ~= ".." then
            local path = FS.path(name)
            local attr = lfs.attributes(path)

            if attr and attr.mode == "file" then
                notes[#notes + 1] = {
                    name = name,
                    path = path,
                    modified = attr.modification or 0,
                }
            end
        end
    end

    table.sort(notes, function(a, b)
        if a.modified == b.modified then
            return a.name:lower() < b.name:lower()
        end

        return a.modified > b.modified
    end)

    return notes
end

function FS.delete_note(name)
    -- Evitar rutas absolutas y componentes de directorio.
    if type(name) ~= "string"
        or name == ""
        or name == "."
        or name == ".."
        or name:find("/", 1, true)
        or name:find("\\", 1, true)
    then
        return false, "Nombre de nota no válido"
    end

    local path = FS.path(name)
    local attr = lfs.attributes(path)

    if not attr or attr.mode ~= "file" then
        return false, "La nota no existe"
    end

    local ok, err = os.remove(path)

    if not ok then
        return false, err
    end

    return true
end

return FS
