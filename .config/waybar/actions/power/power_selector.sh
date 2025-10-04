#!/bin/bash

wofi --conf ~/.config/waybar/actions/power/wofipwrcfg <<< \
'''	Poweroff
	Reboot
	Suspend
	Lock''' \
| sed 's/	P/p/'\
| sed 's/	R/r/'\
| sed 's/	S/s/'\
| sed 's/	L/l/'\
| xargs --no-run-if-empty systemctl


## IN PROGRESS
# 
# DSPLY_PWR='	Poweroff';
# DSPLY_RBT='	Reboot';
# DSPLY_SPD='	Suspend';
# DSPLY_LCK='	Lock';
# 
# CMD_PWR='systemctl poweroff';
# CMD_RBT='systemctl reboot';
# CMD_SPD='systemctl suspend';
# CMD_LCK='systemctl lock';
# 
# DSPLY_LST=("${DSPLY_PWR}" "$DSPLY_RBT" "$DSPLY_SPD" "$DSPLY_LCK");
# CMD_LST=("$CMD_PWR" "$CMD_RBT" "$CMD_SPD" "$CMD_LCK");
# 
# LEN=${#DSPLY_LST[@]};
# echo "Total Items: $LEN";
# echo ${DSPLY_LST[@]};
# 
# for key in "${!DSPLY_LST[@]}" # Iterate over keys
# do
# 	echo "Key: $key; Name: ${DSPLY_LST[$key]}; Command:  ${CMD_LST[$key]}";
# done
# 
# function join_by {
#   local d=${1-} f=${2-}
#   echo $f;
#   if shift 2; then
#     printf %s "$f" "${@/#/$d}"
#   fi
# }
# 
# echo "$(join_by '\n' ${DSPLY_LST})";
# 
