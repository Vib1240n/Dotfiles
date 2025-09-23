#!/bin/bash

echo "=== All SketchyBar Items ==="
sketchybar --query | grep -E '"name"|"type"' | head -30

echo -e "\n=== Control Center Items ==="
sketchybar --query | grep -A2 -B2 "Control Center" | head -20

echo -e "\n=== iStat Menus Items ==="
sketchybar --query | grep -A2 -B2 -i "istat\|bjango" | head -20

echo -e "\n=== All Aliases ==="
sketchybar --query | grep -A5 '"type": "alias"' | head -30
