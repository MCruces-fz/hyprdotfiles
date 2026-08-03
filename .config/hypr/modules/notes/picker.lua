local FS = require("modules.notes.filesystem")

local Picker = {}


local function build_input(notes)
    local lines = {}

    for _, note in ipairs(notes) do
        table.insert(lines, note.name)
    end

    return table.concat(lines, "\n")
end


return Picker
