#!/usr/bin/env bash

set -Eeuo pipefail

# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------

LOG_FILE=/tmp/hypr_script.log
ERR_FILE=/tmp/hypr_script_errors.log

exec >"$LOG_FILE" 2>"$ERR_FILE"
set -x

echo "[$(date '+%F %T')] Executed with args: $*"

# -----------------------------------------------------------------------------
# Environment
# -----------------------------------------------------------------------------

export PATH="$PATH:/usr/bin:/usr/local/bin"

# Only recover the Hyprland instance if we're not already inside one.
if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    export HYPRLAND_INSTANCE_SIGNATURE="$(
        ls -t "$XDG_RUNTIME_DIR"/hypr 2>/dev/null | head -n1
    )"
fi

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------

command -v jq >/dev/null || {
    echo "ERROR: jq is required."
    exit 1
}

command -v hyprctl >/dev/null || {
    echo "ERROR: hyprctl not found."
    exit 1
}

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

dispatch() {
    hyprctl dispatch "$@"
}

noti() {
    notify-send --expire-time=500 "$1"
}

# -----------------------------------------------------------------------------
# Arguments
# -----------------------------------------------------------------------------

operation="${1:-}"
src_wks_id="${2:-}"

# -----------------------------------------------------------------------------
# Read monitor information
# -----------------------------------------------------------------------------

monitors_json="$(hyprctl -j monitors)"

focused_mntr_id="$(
    jq -r '.[] | select(.focused) | .id' <<<"$monitors_json"
)"

focused_wks_id="$(
    jq -r '.[] | select(.focused) | .activeWorkspace.id' <<<"$monitors_json"
)"

unfocused_mntr_id="$(
    jq -r '.[] | select(.focused | not) | .id' <<<"$monitors_json"
)"

unfocused_wks_id="$(
    jq -r '.[] | select(.focused | not) | .activeWorkspace.id' <<<"$monitors_json"
)"

echo "Focused monitor   : ${focused_mntr_id:-none}"
echo "Focused workspace : ${focused_wks_id:-none}"
echo "Other monitor     : ${unfocused_mntr_id:-none}"
echo "Other workspace   : ${unfocused_wks_id:-none}"

single_monitor=false

if [[ -z "${unfocused_mntr_id}" ]]; then
    single_monitor=true
fi

# -----------------------------------------------------------------------------
# Operations
# -----------------------------------------------------------------------------

case "${operation^^}" in

    BRING)

        noti "Bring workspace ${src_wks_id}"

        dispatch moveworkspacetomonitor "$src_wks_id" "$focused_mntr_id"

        # Small delay so Hyprland updates monitor ownership first.
        sleep 0.05

        dispatch workspace "$src_wks_id"
        ;;

    MOVE)

        noti "Move workspace ${src_wks_id}"

        dispatch moveworkspacetomonitor "$src_wks_id" "$focused_mntr_id"
        dispatch movetoworkspace "$src_wks_id"
        ;;

    SWITCH)

        if $single_monitor; then
            noti "Only one monitor connected."
            exit 0
        fi

        noti "Switch workspaces"

        dispatch moveworkspacetomonitor "$unfocused_wks_id" "$focused_mntr_id"
        dispatch moveworkspacetomonitor "$focused_wks_id" "$unfocused_mntr_id"

        dispatch workspace "$unfocused_wks_id"
        ;;

    *)

        noti "Nothing to do."
        ;;

esac
