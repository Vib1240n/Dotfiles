#!/bin/bash
#disk.sh

sketchybar -m --set "$NAME" label="$(df -H | grep -E '^(/dev/disk3s3).' | awk '{ printf ("%s\n", $5) }')"
