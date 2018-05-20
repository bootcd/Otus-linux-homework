#!/bin/bash
exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'

Hi there!

GOOD LUCK!
msgend
sleep 10