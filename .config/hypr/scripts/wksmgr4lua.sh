#!/usr/bin/env bash

# 1. Guardar el log de ejecución limpio
echo "Ejecutado con arg: $1 y $2" >> /tmp/hypr_script.log

# 2. Copiar el entorno COMPLETO del proceso de Hyprland activo para asegurar los sockets
# Esto hereda de forma idéntica la firma, el display de Wayland y el runtime dir.
PID_HYPR=$(pgrep -u "$USER" -x hyprland | head -n 1)
if [ -n "$PID_HYPR" ]; then
    export HYPRLAND_INSTANCE_SIGNATURE=$(tr '\0' '\n' < /proc/$PID_HYPR/environ | grep '^HYPRLAND_INSTANCE_SIGNATURE=' | cut -d= -f2-)
    export XDG_RUNTIME_DIR=$(tr '\0' '\n' < /proc/$PID_HYPR/environ | grep '^XDG_RUNTIME_DIR=' | cut -d= -f2-)
    export WAYLAND_DISPLAY=$(tr '\0' '\n' < /proc/$PID_HYPR/environ | grep '^WAYLAND_DISPLAY=' | cut -d= -f2-)
fi

export PATH=$PATH:/usr/bin:/usr/local/bin

# 3. Separar los errores reales de los textos informativos
exec 2>> /tmp/hypr_script_errors.log

operation=$1  
src_wks_id=$2 

# Extraer los IDs usando JSON
focused_mntr_id=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .id')
focused_wks_id=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

unfocused_mntr_id=$(hyprctl monitors -j | jq '.[] | select(.focused == false) | .id')
unfocused_wks_id=$(hyprctl monitors -j | jq '.[] | select(.focused == false) | .activeWorkspace.id')

# Forzamos a que este bloque de texto vaya a un archivo de diagnóstico limpio, NO al de errores
{
    echo "               Focused monitor ID: $focused_mntr_id"
    echo "  Workspace ID in focused monitor: $focused_wks_id"
    echo "             Unfocused monitor ID: $unfocused_mntr_id"
    echo "Workspace ID in unfocused monitor: $unfocused_wks_id"
} >> /tmp/hypr_script_diagnostico.log

function noti { notify-send --expire-time=500 $1;}


if [[ ${operation^^} == "BRING" ]]; then
    noti "Bring workspace $src_wks_id to focused monitor.";
    
    # SOLO intenta mover el workspace de monitor si realmente hay un monitor enfocado detectado
    if [[ -n "$focused_mntr_id" && -n "$unfocused_mntr_id" ]]; then
        hyprctl dispatch moveworkspacetomonitor "$src_wks_id" "$focused_mntr_id";
        sleep 0.05
    fi
    
    # Cambiar al espacio de trabajo (esto funciona siempre, con 1 o más monitores)
    hyprctl dispatch workspace "$src_wks_id";

elif [[ ${operation^^} == "SWITCH" ]]; then
    # El intercambio solo tiene sentido si hay dos monitores activos
    if [[ -n "$unfocused_wks_id" && -n "$focused_mntr_id" && -n "$unfocused_mntr_id" ]]; then
        noti "Switch workspaces between monitors.";
        hyprctl dispatch moveworkspacetomonitor "$unfocused_wks_id" "$focused_mntr_id";
        hyprctl dispatch moveworkspacetomonitor "$focused_wks_id" "$unfocused_mntr_id";
        hyprctl dispatch workspace "$unfocused_wks_id";
    else
        noti "Switch omitido: Solo hay un monitor activo.";
    fi

elif [[ ${operation^^} == "MOVE" ]]; then
    noti "Move workspace $src_wks_id to focused monitor.";
    if [[ -n "$focused_mntr_id" && -n "$unfocused_mntr_id" ]]; then
        hyprctl dispatch moveworkspacetomonitor "$src_wks_id" "$focused_mntr_id";
    fi
    hyprctl dispatch movetoworkspace "$src_wks_id";
else
   noti "Nothing to do with workspaces.";
fi

