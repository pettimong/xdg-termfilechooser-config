#!/bin/bash
export PATH="$HOME/.cargo/bin:$PATH"
# sk-wrapper.sh
# For use with xdg-desktop-portal-termfilechooser (hunkyburrito fork)
#
# Argument spec:
#   $1 = multiple  (0/1)
#   $2 = directory (0/1)
#   $3 = save      (0/1)
#   $4 = path      (suggested dir — ignored; always searches $HOME)
#   $5 = out       (portal result file)
#
# Note: hunkyburrito fork adds file:// prefix automatically.
#       Do NOT add it in this wrapper.

multiple="$1"
portal_file="$5"

: > "$portal_file"
tmp_output=$(mktemp)

if [[ "$multiple" == "1" ]]; then
    sk_multi_flag="-m --bind tab:toggle+down"
    sk_prompt="Select Files (Tab=select, Enter=confirm) > "
else
    sk_multi_flag="--no-multi"
    sk_prompt="Select File > "
fi

kitty --class "filechooser" --title "sk-chooser" \
    bash -c "fd --type f --hidden \
                --exclude .git --exclude .cargo --exclude .rustup \
                --max-depth 5 . \"$HOME\" \
             | sk $sk_multi_flag --prompt \"$sk_prompt\" > \"$tmp_output\""

if [[ -s "$tmp_output" ]]; then
    cp "$tmp_output" "$portal_file"
else
    : > "$portal_file"
fi

rm -f "$tmp_output"
exit 0
