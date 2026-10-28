#!/bin/bash
hyprctl dispatch 'hl.dsp.exec_cmd("hyprshutdown --top-label \"Killing in the name of SIGKILL!\" --post-cmd \"systemctl poweroff\"")'
