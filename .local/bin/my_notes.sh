#!/bin/bash
# Directorio donde se guardarán tus notas
# NOTES_DIR="$XDG_DOCUMENTS_DIR/notes/"
NOTES_DIR="$HOME/documents/notes/"
mkdir -p "$NOTES_DIR"

# 1. Listar archivos por fecha de modificación (-t)
# 2. FZF permite buscar por nombre. 
# 3. Si escribes algo nuevo y pulsas Enter, se creará ese archivo.
# SELECTION=$(ls -t "$NOTES_DIR" | fzf --preview "cat $NOTES_DIR/{}" --placeholder "Escribe título o selecciona nota...")

# 1. Listamos archivos por fecha
# 2. --print-query permite que si lo que escribes no existe, se use como nombre de archivo
# 3. 'tail -1' toma el nombre del archivo (ya sea el seleccionado o el escrito)
SELECTION=$(ls -t "$NOTES_DIR" | fzf \
	--preview "cat $NOTES_DIR/{}" \
    --header "🛒 Ctrl+D: Drop note | Enter: Add/Edit" \
    --bind "ctrl-d:execute(rm -f $NOTES_DIR/{})+reload(ls -t $NOTES_DIR)" \
	--print-query | tail -1)

if [ -z "$SELECTION" ]; then
    # Si escapas de fzf sin elegir, no hace nada
    exit 0
else
	# Si la seleccion no tiene extension, le añadimos .md por comodidad
	
	if [[ "$SELECTION" != *.* ]]; then
		SELECTION="$SELECTION.md"
	fi

    # Abre la nota (existente o nueva) con micro
    nvim "$NOTES_DIR/$SELECTION"
    # micro "$NOTES_DIR/$SELECTION"
fi
