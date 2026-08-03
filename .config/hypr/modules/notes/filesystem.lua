local lfs = require("lfs")
local Config = require("modules.notes.config")

local FS = {}

function FS.path(name)
	return Config.notes_dir.."/"..name
end

function FS.exists(name)
    return lfs.attributes(FS.path(name)) ~= nil
end

function FS.ensure_directory()
    local attr = lfs.attributes(Config.notes_dir)
    if attr then
        return true
    end

    local ok, err = lfs.mkdir(Config.notes_dir)
    if not ok then
        error(err)
    end
    return true
end

function FS.list_notes()
    FS.ensure_directory()
    local notes = {}

    for name in lfs.dir(Config.notes_dir) do
        -- Ignorar "." y ".."
        if name ~= "." and name ~= ".." then
            local path = FS.path(name)
            local attr = lfs.attributes(path)
            -- Sólo archivos normales
            if attr and attr.mode == "file" then
                table.insert(notes, {
                    name = name,
                    path = path,
                    modified = attr.modification,
                })
            end
        end
    end
    table.sort(notes, function(a, b)
        return a.modified > b.modified
    end)
    return notes
end

return FS
