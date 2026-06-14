#!/bin/bash
export PATH="$HOME/.cargo/bin:$PATH"

# termfilechooser の環境変数方式に対応
if [[ -n "$termfilechooser_output" ]]; then
    portal_file="$termfilechooser_output"
    target_dir="${termfilechooser_path:-$HOME}"
    multiple_mode="${termfilechooser_multiple:-0}"
else
    multiple_mode="0"
    target_dir="${4:-$HOME}"
    portal_file="$5"
fi

if [ ! -d "$target_dir" ]; then target_dir="$HOME"; fi

tmpfile=$(mktemp /tmp/yazi-chooser.XXXXXX)

kitty --instance-group "fc-$$" --title "filechooser" -- \
    yazi --chooser-file="$tmpfile" "$target_dir"

if [[ -f "$tmpfile" && -s "$tmpfile" ]]; then
    # file:// プレフィックスを付与（zen-browser 対応）
    sed 's|^|file://|' "$tmpfile" > "$portal_file"
    rm -f "$tmpfile"
    exit 0
else
    rm -f "$tmpfile"
    : > "$portal_file"
    exit 1
fi
