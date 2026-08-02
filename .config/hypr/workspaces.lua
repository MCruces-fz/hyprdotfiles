-- ~/.config/hypr/workspaces.lua

local Workspace = {}


local function focused_monitor()
    return hl.get_active_monitor()
end


local function other_monitor()
    local active = focused_monitor()
    if not active then
        return nil
    end
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.id ~= active.id then
            return monitor
        end
    end
    return nil
end


function Workspace.bring(id)
    local monitor = focused_monitor()

    if not monitor then
        return
    end

	-- ESTO FUNCIONA
	hl.dispatch(hl.dsp.focus({workspace=tostring(id)}))

	-- Pero no sé si lo estoy cambiando de monitor, así que dejo todo esto y lo siguiente comentado
	hl.dispatch(hl.dsp.workspace.move({workspace=id, monitor=monitor.id}))

	--[[

    -- Equivalent to: hyprctl dispatch workspace <id>
    hl.dispatch(
        hl.dsp.global(
            "workspace",
            tostring(id)
        )
    )
    -- Now the workspace should exist
    local workspace = hl.get_workspace(id)

	hl.notification.create({text="workspace " .. workspace.name .. " (" .. workspace.description.. ") is in monitor ", duration=5000})

    if not workspace then
        return
    end
    -- Equivalent to:
    -- hyprctl dispatch moveworkspacetomonitor <id> <monitor>
    hl.dispatch(
        hl.dsp.workspace.move({
            workspace = workspace,
            monitor = monitor,
        })
    )
	]]
end


function Workspace.move_window(id)
    -- Ensure workspace exists
    hl.dispatch(
        hl.dsp.global(
            "workspace",
            tostring(id)
        )
    )
    local workspace = hl.get_workspace(id)
    if not workspace then
		hl.notification.create({text="Posiblemente no exista el workspace "..id, duration=5000})
        -- return
		workspace=id
    end
    hl.dispatch(
        hl.dsp.window.move({
            workspace = workspace,
        })
    )
end


function Workspace.swap_monitors()
    local monitor1 = focused_monitor()
    local monitor2 = other_monitor()
    if not monitor1 or not monitor2 then
		hl.notification.create({text="Sólo tienes un monitor, colega", duration=5000})
        return
    end
    hl.dispatch(
        hl.dsp.workspace.swap_monitors({
            monitor1 = monitor1,
            monitor2 = monitor2,
        })
    )
end


return Workspace
