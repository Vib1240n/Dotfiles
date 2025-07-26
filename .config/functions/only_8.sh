#! /bin/bash


LEN=$(yabai -m query --displays | jq ".[].spaces | length")
if (( LEN == 8)); then
  echo "Already 8 spaces"
  exit 0;
else
for ((i = 0; i < LEN ; i++));
do
  if [[ $(yabai -m query --spaces | jq -r ".[$i].windows = []") ]] && ((i >= 8));
  then
    yabai -m space "$i" --destroy;
    echo "Destroying space $i";
    set -e
  fi;
done
fi;
