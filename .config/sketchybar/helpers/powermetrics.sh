#!/bin/bash
unset TERMINFO
exec sudo /usr/bin/powermetrics "$@"
