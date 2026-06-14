# Setup Guide & Troubleshooting

Tested on: **Arch Linux / Hyprland / Wayland / Zen Browser**

---

## Prerequisites

### 1. hyprland-portals.conf

Create `~/.config/xdg-desktop-portal/hyprland-portals.conf`:

```ini
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=termfilechooser
```

### 2. Add `hyprland` to termfilechooser.portal

The default `UseIn` list does not include `hyprland`. Add it manually:

```bash
sudo sed -i 's/UseIn=/UseIn=hyprland;/' \
    /usr/share/xdg-desktop-portal/portals/termfilechooser.portal

# Verify
cat /usr/share/xdg-desktop-portal/portals/termfilechooser.portal
```

### 3. Remove conflicting portals.conf

If `~/.config/xdg-desktop-portal/portals.conf` exists and contains `default=gtk`,
it overrides `hyprland-portals.conf`. Rename it:

```bash
mv ~/.config/xdg-desktop-portal/portals.conf \
   ~/.config/xdg-desktop-portal/portals.conf.bak
```

### 4. Fix graphical-session.target for Hyprland

`xdg-desktop-portal` requires `graphical-session.target` to be active.
On Hyprland, this is not activated automatically unless explicitly triggered.

Create `~/.config/systemd/user/hyprland-session.target`:

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/hyprland-session.target << 'EOF'
[Unit]
Description=Hyprland compositor session
Documentation=man:systemd.special(7)
BindsTo=graphical-session.target
Wants=graphical-session-pre.target
After=graphical-session-pre.target
EOF

systemctl --user daemon-reload
```

Add to `~/.config/hypr/hyprland.conf`
(remove any existing manual `xdg-desktop-portal` launch lines):

```ini
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user start hyprland-session.target
```

### 5. config section name

The correct section name is `[filechooser]`. Using `[cmd]` will silently fail
and fall back to the default `ranger-wrapper.sh`.

```ini
[filechooser]
cmd=$HOME/.config/xdg-desktop-portal-termfilechooser/sk-wrapper.sh
```

> **Note**: Whether `$HOME` is expanded in `cmd=` depends on the termfilechooser version.
> If it does not work, use the absolute path (e.g. `/home/username/.config/...`).

### 6. skim PATH issue

When launched via systemd, `~/.cargo/bin` is not in `$PATH`.
The wrapper scripts handle this automatically:

```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

If `sk` is installed in a non-standard location, edit this line in the wrapper scripts.

---

## Firefox / Zen Browser specific settings

Firefox-based browsers (including Zen Browser) ignore `GTK_USE_PORTAL=1`.
You must enable the portal file picker in `about:config`:

1. Open `about:config` (use `Ctrl+L` if the address bar is hidden)
2. Search for `widget.use-xdg-desktop-portal.file-picker`
3. Set the value to `1`

---

## Verification

```bash
# Check graphical-session.target is active
systemctl --user status graphical-session.target

# Check xdg-desktop-portal is running
systemctl --user status xdg-desktop-portal

# Check termfilechooser is reading the correct config
/usr/lib/xdg-desktop-portal-termfilechooser -l DEBUG 2>&1 | head -3
# → config: cmd: /home/YOUR_USER/.config/.../sk-wrapper.sh

# Monitor DBus while opening a file dialog in the browser
dbus-monitor --session "interface='org.freedesktop.portal.FileChooser'"
```

---

## Troubleshooting

### GTK file dialog appears instead of TUI

1. Check `widget.use-xdg-desktop-portal.file-picker` in `about:config` — must be `1`
2. Check `systemctl --user status xdg-desktop-portal` — must be `active (running)`
3. Check that `hyprland-portals.conf` exists and conflicting `portals.conf` is removed

### kitty opens and closes immediately

Most likely `sk` is not found in `$PATH`. Verify:

```bash
which sk   # should return ~/.cargo/bin/sk
```

The wrapper scripts add `~/.cargo/bin` to `$PATH` automatically.
If `sk` is installed elsewhere, edit the `export PATH=` line in the wrapper.

### config: cmd shows ranger-wrapper.sh

The section name in your config file is wrong.
It must be `[filechooser]`, not `[cmd]`.

### xdg-desktop-portal fails with "Dependency failed"

`graphical-session.target` is inactive. Follow step 4 above (create hyprland-session.target).

### File upload fails on Gemini (single window workspace)

**Symptom**: kitty opens and file selection works, but the file is not uploaded to Gemini.
The portal file is correctly written with the selected path, but Gemini ignores the result.
This only happens when Zen Browser is the sole window on the workspace.
Claude.ai and other sites are not affected.

**Cause**: Suspected Wayland XDG Activation Token issue. When Zen Browser is the only window
on a workspace, the token handoff between the browser and the portal may fail silently.
The portal log shows no errors — the failure occurs before the portal is even called.

**Workaround**: Keep at least one other window on the same workspace as Zen Browser.

---
---

# セットアップガイドとトラブルシューティング（日本語）

動作確認環境: **Arch Linux / Hyprland / Wayland / Zen Browser**

---

## 前提条件

### 1. hyprland-portals.conf

`~/.config/xdg-desktop-portal/hyprland-portals.conf` を作成します:

```ini
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=termfilechooser
```

### 2. termfilechooser.portal に hyprland を追加

デフォルトの `UseIn` リストに `hyprland` が含まれていないため、手動で追加します:

```bash
sudo sed -i 's/UseIn=/UseIn=hyprland;/' \
    /usr/share/xdg-desktop-portal/portals/termfilechooser.portal

# 確認
cat /usr/share/xdg-desktop-portal/portals/termfilechooser.portal
```

### 3. 競合する portals.conf を退避

`~/.config/xdg-desktop-portal/portals.conf` に `default=gtk` が書かれていると
`hyprland-portals.conf` より優先されます。退避してください:

```bash
mv ~/.config/xdg-desktop-portal/portals.conf \
   ~/.config/xdg-desktop-portal/portals.conf.bak
```

### 4. Hyprland で graphical-session.target を有効化

`xdg-desktop-portal` は `graphical-session.target` が active でないと起動しません。
Hyprland では明示的に起動する必要があります。

`~/.config/systemd/user/hyprland-session.target` を作成します:

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/hyprland-session.target << 'EOF'
[Unit]
Description=Hyprland compositor session
Documentation=man:systemd.special(7)
BindsTo=graphical-session.target
Wants=graphical-session-pre.target
After=graphical-session-pre.target
EOF

systemctl --user daemon-reload
```

`~/.config/hypr/hyprland.conf` に追加します
（既存の手動 `xdg-desktop-portal` 起動行は削除してください）:

```ini
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user start hyprland-session.target
```

### 5. config のセクション名

正しいセクション名は `[filechooser]` です。`[cmd]` にするとエラーなく無視され、
デフォルトの `ranger-wrapper.sh` が使われ続けます。

```ini
[filechooser]
cmd=$HOME/.config/xdg-desktop-portal-termfilechooser/sk-wrapper.sh
```

> **注意**: `cmd=` 内の `$HOME` が展開されるかは termfilechooser のバージョン依存です。
> 動作しない場合は絶対パス（例: `/home/username/.config/...`）に書き換えてください。

### 6. skim の PATH 問題

systemd 経由で起動すると `~/.cargo/bin` が `$PATH` に含まれません。
ラッパースクリプトで自動的に追加しています:

```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

`sk` を標準以外の場所にインストールしている場合は、この行を編集してください。

---

## Firefox / Zen Browser の設定

Firefox 系ブラウザ（Zen Browser 含む）は `GTK_USE_PORTAL=1` を無視します。
`about:config` でポータル経由のファイル選択を個別に有効化する必要があります:

1. `about:config` を開く（アドレスバーを非表示にしている場合は `Ctrl+L`）
2. `widget.use-xdg-desktop-portal.file-picker` を検索
3. 値を `1` に設定

---

## 動作確認

```bash
# graphical-session.target が active か確認
systemctl --user status graphical-session.target

# xdg-desktop-portal 本体が起動しているか確認
systemctl --user status xdg-desktop-portal

# termfilechooser が正しい config を読んでいるか確認
/usr/lib/xdg-desktop-portal-termfilechooser -l DEBUG 2>&1 | head -3
# → config: cmd: /home/YOUR_USER/.config/.../sk-wrapper.sh が出ればOK

# ブラウザでファイル選択を開きながら DBus の動きを確認
dbus-monitor --session "interface='org.freedesktop.portal.FileChooser'"
```

---

## トラブルシューティング

### GTKダイアログが出て TUI が起動しない

1. `about:config` で `widget.use-xdg-desktop-portal.file-picker` が `1` になっているか確認
2. `systemctl --user status xdg-desktop-portal` が `active (running)` になっているか確認
3. `hyprland-portals.conf` が存在し、競合する `portals.conf` が退避済みか確認

### kitty が一瞬で閉じる

`$PATH` に `sk` が見つからないのが原因です。確認:

```bash
which sk   # → ~/.cargo/bin/sk が返るはず
```

ラッパースクリプトは自動的に `~/.cargo/bin` を `$PATH` に追加しています。
`sk` を別の場所にインストールしている場合は、ラッパー内の `export PATH=` 行を編集してください。

### config: cmd が ranger-wrapper.sh になっている

config のセクション名が間違っています。`[cmd]` ではなく `[filechooser]` にしてください。

### xdg-desktop-portal が "Dependency failed" で起動しない

`graphical-session.target` が inactive です。手順4（hyprland-session.target の作成）を実施してください。
