#!/bin/bash

# Comprobamos si la ventana ya existe (guarda 0 si existe, 1 si no)
hyprctl clients | grep -E '^[[:space:]]+class: quick_note$' -q
window_exists=$?

# Si NO existe, la creamos
if [ $window_exists -ne 0 ]; then
    # hyprctl dispatch exec "[workspace special:notes silent;float;size 75% 75%;center] kitty --class quick_note -e ~/.local/bin/my_notes.sh"
	# hyprctl dispatch exec "[workspace special:notes silent;float;windowrule size 75% 75%;windowrule center] kitty --class quick_note -e ~/.local/bin/my_notes.sh"
	hyprctl dispatch exec "[workspace special:notes silent;float;center] kitty --class quick_note --override remember_window_size=no --override initial_window_width=75c --override initial_window_height=25c -e ~/.local/bin/my_notes.sh"
    sleep 0.15
fi

# Alternamos la visibilidad del workspace especial siempre
hyprctl dispatch togglespecialworkspace notes

# Forzamos el foco SOLO cuando vamos a mostrar la ventana
if [ $window_exists -ne 0 ]; then
    hyprctl dispatch focuswindow "class:quick_note"
fi
