#! /bin/bash


LEN=$(yabai -m query --displays | jq -re ".[].spaces | length")
echo $LEN


NAMES=("browser" "terminal" "3d-printing" "obsidian" "productivity" "system" "empty7" "empty8")
if ((LEN > 8));then
  echo "default spaces already created";
elif ((LEN < 8));then
  INDEX=$((8 - LEN));
  echo "spaces to create: "$INDEX;
  for i in $(seq "$((LEN+1))" 8);
  do
    echo "$i"
    yabai -m space "{$i}" --create; yabai -m space "$i" --label="${NAMES[$i]}";
  done
else
  set -e
fi;
