
-- ~/.config/hypr/modules/notes/init.lua

-- Permite ejecutar este archivo directamente con:
-- lua ~/.config/hypr/modules/notes/init.lua

local HOME = assert(os.getenv("HOME"), "HOME no está definido")

package.path = HOME .. "/.config/hypr/?.lua;"
    .. HOME .. "/.config/hypr/?/init.lua;"
    .. package.path

local FS = require("modules.notes.filesystem")
local Picker = require("modules.notes.picker")
local Editor = require("modules.notes.editor")

local function main()
    FS.ensure_directory()

    local selection = Picker.run()

    if not selection then
        return
    end

    Editor.open(selection)
end

local ok, err = pcall(main)

if not ok then
    io.stderr:write("Error en Quick Notes: " .. tostring(err) .. "\n")
    os.exit(1)
end
