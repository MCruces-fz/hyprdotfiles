#!/usr/bin/env bash

operation=$1  # Operation: SWITCH, BRING
src_wks_id=$2 # Source Workspace ID

monitors_output="$(hyprctl monitors)"

# Define variables
#  - $focused_mntr_id: Focused monitor ID.
#  - $focused_wks_id: Workspace ID in focused monitor.
#  - $unfocused_mntr_id: Unfocused monitor ID.
#  - $unfocused_wks_id: Workspaace ID in unfocused monitor.
while IFS= read -r line; do
    if [[ $line =~ ^Monitor[[:space:]]+([^[:space:]]+)[[:space:]]+\(ID[[:space:]]+([0-9]+)\): ]]; then
        current_monitor="${BASH_REMATCH[1]}"   # eDP-1 o HDMI-A-2
        current_monitor_id="${BASH_REMATCH[2]}" # 0 o 1
        current_focus=""
        active_wks=""
    fi

    if [[ $line =~ focused:\ (yes|no) ]]; then
        current_focus="${BASH_REMATCH[1]}"
		if [[ -n "$active_wks" ]]; then
		    if [[ $current_focus == "yes" ]]; then 
				focused_wks_id="$active_wks"; 
				focused_mntr_id="$current_monitor_id";
			fi
		    if [[ $current_focus == "no" ]]; then 
				unfocused_wks_id="$active_wks"; 
				unfocused_mntr_id="$current_monitor_id";
			fi
		fi
    fi

    if [[ $line =~ active[[:space:]]workspace:[[:space:]]+([0-9]+) ]]; then
        active_wks="${BASH_REMATCH[1]}"
        if [[ $current_focus == "yes" ]]; then focused_wks_id="$active_wks"; fi
		if [[ $current_focus == "no" ]]; then unfocused_wks_id="$active_wks"; fi
    fi
done <<< "$monitors_output"

echo "               Focused monitor ID: $focused_mntr_id"
echo "  Workspace ID in focused monitor: $focused_wks_id"
echo "             Unfocused monitor ID: $unfocused_mntr_id"
echo "Workspace ID in unfocused monitor: $unfocused_wks_id"

function noti { notify-send --expire-time=500 $1;}

if [[ ${operation^^} == "BRING" ]]; then
    noti "Bring workspace $src_wks_id to focused monitor.";
	hyprctl dispatch moveworkspacetomonitor $src_wks_id $focused_mntr_id;
	hyprctl dispatch workspace $src_wks_id;
elif [[ ${operation^^} == "SWITCH" ]]; then
    noti "Switch workspaces between monitors.";
	hyprctl dispatch moveworkspacetomonitor $unfocused_wks_id $focused_mntr_id;
	hyprctl dispatch moveworkspacetomonitor $focused_wks_id $unfocused_mntr_id;
	hyprctl dispatch workspace $unfocused_wks_id;
elif [[ ${operation^^} == "MOVE" ]]; then
    noti "Move workspace $src_wks_id to focused monitor.";
	hyprctl dispatch moveworkspacetomonitor $src_wks_id $focused_mntr_id;
	hyprctl dispatch movetoworkspace $src_wks_id;
else
   noti "Nothing to do with workspaces.";
fi
