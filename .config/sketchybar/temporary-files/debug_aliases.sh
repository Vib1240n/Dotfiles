#!/bin/bash

# Debug script to find available Control Center aliases
echo "=== Available Control Center Items ==="
sketchybar --query | grep -i "control center" | head -20

echo -e "\n=== iStat Menus specific items ==="  
sketchybar --query | grep -i "istat" | head -10

echo -e "\n=== All aliases ==="
sketchybar --query | grep '"alias"' | head -15
