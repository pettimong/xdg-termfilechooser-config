#!/bin/bash
export PATH="$HOME/.cargo/bin:$PATH"
# yazi-wrapper.sh
# For use with xdg-desktop-portal-termfilechooser (hunkyburrito fork)
#
# Argument spec:
#   $1 = multiple  (0/1)
#   $2 = directory (0/1)
#   $3 = save      (0/1)
#   $4 = path      (suggested dir — ignored; always starts at $HOME)
#   $5 = out       (portal result file)
#
# Note: hunkyburrito fork adds file:// prefix automatically.
#       Do NOT add it in this wrapper.

multiple="$1"
portal_file="$5"

tmpfile=$(mktemp /tmp/yazi-chooser.XXXXXX)

kitty --class "filechooser" --title "filechooser" -- \
    yazi --chooser-file="$tmpfile" "$HOME"

if [[ -f "$tmpfile" && -s "$tmpfile" ]]; then
    cp "$tmpfile" "$portal_file"
    rm -f "$tmpfile"
    exit 0
else
    rm -f "$tmpfile"
    : > "$portal_file"
    exit 1
fi
