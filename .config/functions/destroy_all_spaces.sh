#! /bin/bash

# yabai -m query --spaces | jq -re "map(select(.\"windows\" != []))"
TOTAL_SPACES=$(yabai -m query --spaces | jq -re 'map(select(."index")) | last'.index)
for i in $(seq $TOTAL_SPACES 1);
do
  if $(yabai -m query --spaces | jq -r ".[$i].windows != []");
  then 
    echo "Has windows";
  else
    yabai -m space --destroy "$1";
  fi;
done

