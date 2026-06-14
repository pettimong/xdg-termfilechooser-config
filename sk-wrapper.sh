#!/bin/bash
export PATH="$HOME/.cargo/bin:$PATH"
# sk-wrapper.sh (Pure Rust & Absolute Zen Edition)

# ---- 引数と環境変数の動的ハイブリッド判定 ----
# termfilechooser の新しい仕様と、ブラウザから渡される従来の引数位置を両方カバー
if [[ -n "$termfilechooser_output" ]]; then
    portal_file="$termfilechooser_output"
    target_dir="${termfilechooser_path:-$HOME}"
    multiple_mode="${termfilechooser_multiple:-0}"
elif [[ "$5" == "true" || "$5" == "false" ]]; then
    multiple_mode=$( [ "$5" == "true" ] && echo 1 || echo 0 )
    target_dir="${4:-$HOME}"
    portal_file="$6"
else
    multiple_mode="0"
    target_dir="${4:-$HOME}"
    portal_file="$5"
fi

# フォールバック処理
if [ ! -d "$target_dir" ]; then target_dir="$HOME"; fi
: > "$portal_file"

# ---- sk (skim) の引数調整 ----
if [[ "$multiple_mode" == "1" ]]; then
    sk_opt="-m --prompt='Select Files (Tab to select, Enter to confirm) ❯ '"
else
    sk_opt="--no-multi --prompt='Select File ❯ '"
fi

# ---- kitty + fd + sk の実行 ----
tmp_output=$(mktemp)

kitty --class "filechooser" --title "sk-chooser" \
    bash -c "fd --type f --hidden --exclude .git . '$target_dir' \
             | sk $sk_opt > '$tmp_output'"

# ---- 🔴 ここがZen Browser（Firefox）の急所 🔴 ----
# 選択されたパスの先頭に "file://" を付与してポータルに渡す
# （スラッシュが3つ並ぶ「file:///home/...」の形式を正確に作ります）
if [[ -s "$tmp_output" ]]; then
    sed 's|^|file://|' "$tmp_output" > "$portal_file"
else
    : > "$portal_file"
fi

rm -f "$tmp_output"
exit 0
