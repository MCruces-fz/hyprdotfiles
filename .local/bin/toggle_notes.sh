#!/bin/bash

# Comprobamos si la ventana ya existe (guarda 0 si existe, 1 si no)
hyprctl clients | grep -q "class: quick_note"
window_exists=$?

# Si NO existe, la creamos
if [ $window_exists -ne 0 ]; then
    hyprctl dispatch exec "[workspace special:notes silent;float;size 75% 75%;center] kitty --class quick_note -e ~/.local/bin/my_notes.sh"
    sleep 0.1
fi

# Alternamos la visibilidad del workspace especial siempre
hyprctl dispatch togglespecialworkspace notes

# Forzamos el foco SOLO cuando vamos a mostrar la ventana
if [ $window_exists -ne 0 ]; then
    hyprctl dispatch focuswindow "class:quick_note"
fi
