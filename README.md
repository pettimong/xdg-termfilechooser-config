# xdg-desktop-portal-termfilechooser config

TUI file chooser wrappers for [xdg-desktop-portal-termfilechooser](https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser), supporting both [skim](https://github.com/skim-rs/skim) (fuzzy finder) and [yazi](https://github.com/sxyazi/yazi) (TUI file manager).

Tested on: **Arch Linux / Hyprland / Wayland / Zen Browser**

> **Note**: These wrappers are written for the [hunkyburrito fork](https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser).
> The GermainZ fork (now archived) has a different argument spec and is not compatible.

---

## Files

```
config.example      # Configuration template
sk-wrapper.sh       # Wrapper using fd + skim (fuzzy finder)
yazi-wrapper.sh     # Wrapper using yazi (TUI file manager)
setup.md            # Setup guide and troubleshooting
```

---

## Requirements

| Tool | Description | Install (Arch) |
|------|-------------|----------------|
| [xdg-desktop-portal-termfilechooser](https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser) | Portal backend (hunkyburrito fork) | `paru -S xdg-desktop-portal-termfilechooser-hunkyburrito-git` |
| [kitty](https://sw.kovidgoyal.net/kitty/) | Terminal emulator | `pacman -S kitty` |
| [fd](https://github.com/sharkdp/fd) | File finder (for sk-wrapper) | `pacman -S fd` |
| [skim](https://github.com/skim-rs/skim) | Fuzzy finder (for sk-wrapper) | `cargo install skim` |
| [yazi](https://github.com/sxyazi/yazi) | TUI file manager (for yazi-wrapper) | `pacman -S yazi` |

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/pettimong/xdg-termfilechooser-config
cd xdg-termfilechooser-config

# 2. Copy files
mkdir -p ~/.config/xdg-desktop-portal-termfilechooser
cp sk-wrapper.sh yazi-wrapper.sh ~/.config/xdg-desktop-portal-termfilechooser/
cp config.example ~/.config/xdg-desktop-portal-termfilechooser/config
chmod +x ~/.config/xdg-desktop-portal-termfilechooser/*.sh

# 3. Edit config — uncomment the wrapper you want to use
vim ~/.config/xdg-desktop-portal-termfilechooser/config

# 4. Restart the service
systemctl --user restart xdg-desktop-portal-termfilechooser
```

---

## Switching Between sk and yazi

Edit `~/.config/xdg-desktop-portal-termfilechooser/config` and restart the service:

```ini
[filechooser]
# Use skim (fuzzy finder):
cmd=/home/YOUR_USERNAME/.config/xdg-desktop-portal-termfilechooser/sk-wrapper.sh

# Use yazi (file manager) — comment out the line above and uncomment below:
# cmd=/home/YOUR_USERNAME/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
```

```bash
systemctl --user restart xdg-desktop-portal-termfilechooser
```

---

## Notes

- The `cmd=` path must be an absolute path. `$HOME` may not be expanded depending on the termfilechooser version. Use `/home/username/...` explicitly.
- skim (`sk`) is installed via cargo by default (`~/.cargo/bin/sk`). The wrappers add `~/.cargo/bin` to `$PATH` automatically, so no manual PATH configuration is needed.
- Both wrappers always search from `$HOME`, ignoring the suggested directory passed by the browser (`$4`). This is intentional — the suggested directory is typically the directory of the page triggering the dialog, which is rarely useful.
- Multiple file selection works with sk-wrapper (Tab to select, Enter to confirm). yazi-wrapper supports multiple selection natively via yazi's built-in chooser mode.
- File upload on Gemini may fail depending on the browser window layout or workspace configuration. The portal itself works correctly. Reported as [zen-browser/desktop#14285](https://github.com/zen-browser/desktop/issues/14285). See `setup.md` for details and workarounds.

---

## sk vs yazi

| | sk (skim) | yazi |
|---|---|---|
| Style | Fuzzy finder | TUI file manager |
| Best for | Fast search by filename | Visual directory browsing |
| Feel | CLI-native | Close to GUI file manager |

---

## License

MIT

---
---

# xdg-desktop-portal-termfilechooser config（日本語）

[xdg-desktop-portal-termfilechooser](https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser) 向けのTUIファイルチューザーラッパースクリプト群です。fuzzy finder の [skim](https://github.com/skim-rs/skim) と、TUIファイルマネージャーの [yazi](https://github.com/sxyazi/yazi) の両方に対応しています。

動作確認環境: **Arch Linux / Hyprland / Wayland / Zen Browser**

> **注意**: このラッパーは [hunkyburrito fork](https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser) 向けに書かれています。
> GermainZ fork（アーカイブ済み）とは引数仕様が異なるため互換性がありません。

---

## ファイル構成

```
config.example      # 設定ファイルのテンプレート
sk-wrapper.sh       # fd + skim を使うラッパー（fuzzy finder）
yazi-wrapper.sh     # yazi を使うラッパー（TUIファイルマネージャー）
setup.md            # セットアップガイドとトラブルシューティング
```

---

## 必要なツール

| ツール | 説明 | インストール (Arch) |
|--------|------|---------------------|
| [xdg-desktop-portal-termfilechooser](https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser) | ポータルバックエンド（hunkyburrito fork） | `paru -S xdg-desktop-portal-termfilechooser-hunkyburrito-git` |
| [kitty](https://sw.kovidgoyal.net/kitty/) | ターミナルエミュレーター | `pacman -S kitty` |
| [fd](https://github.com/sharkdp/fd) | ファイル検索（sk-wrapper用） | `pacman -S fd` |
| [skim](https://github.com/skim-rs/skim) | fuzzy finder（sk-wrapper用） | `cargo install skim` |
| [yazi](https://github.com/sxyazi/yazi) | TUIファイルマネージャー（yazi-wrapper用） | `pacman -S yazi` |

---

## セットアップ手順

```bash
# 1. クローン
git clone https://github.com/pettimong/xdg-termfilechooser-config
cd xdg-termfilechooser-config

# 2. ファイルをコピー
mkdir -p ~/.config/xdg-desktop-portal-termfilechooser
cp sk-wrapper.sh yazi-wrapper.sh ~/.config/xdg-desktop-portal-termfilechooser/
cp config.example ~/.config/xdg-desktop-portal-termfilechooser/config
chmod +x ~/.config/xdg-desktop-portal-termfilechooser/*.sh

# 3. config を編集 — 使いたいラッパーのコメントアウトを外す
vim ~/.config/xdg-desktop-portal-termfilechooser/config

# 4. サービスを再起動
systemctl --user restart xdg-desktop-portal-termfilechooser
```

---

## sk と yazi の切り替え

`~/.config/xdg-desktop-portal-termfilechooser/config` を編集してサービスを再起動するだけです:

```ini
[filechooser]
# skim を使う場合:
cmd=/home/YOUR_USERNAME/.config/xdg-desktop-portal-termfilechooser/sk-wrapper.sh

# yazi を使う場合（上をコメントアウトして下を有効化）:
# cmd=/home/YOUR_USERNAME/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
```

```bash
systemctl --user restart xdg-desktop-portal-termfilechooser
```

---

## 注意事項

- `cmd=` のパスは絶対パスで指定してください。termfilechooser のバージョンによっては `$HOME` が展開されない場合があります。`/home/username/...` と明示的に書くのが確実です。
- skim (`sk`) はデフォルトで cargo 経由でインストールされます（`~/.cargo/bin/sk`）。ラッパースクリプトが自動的に `~/.cargo/bin` を `$PATH` に追加するので、手動設定は不要です。
- どちらのラッパーも常に `$HOME` から検索します。ブラウザから渡される推奨ディレクトリ（`$4`）は無視します。推奨ディレクトリはダイアログを開いたページのディレクトリが渡されることが多く、通常は有用でないためです。
- 複数ファイル選択は sk-wrapper で動作します（Tab で選択、Enter で確定）。yazi-wrapper は yazi のchooserモードを通じて複数選択に対応しています。
- Gemini へのファイルアップロードは、ブラウザのウィンドウレイアウトやワークスペースの構成によって失敗する場合があります。ポータル自体は正常に動作しています。[zen-browser/desktop#14285](https://github.com/zen-browser/desktop/issues/14285) として報告済みです。詳細と回避策は `setup.md` を参照してください。

---

## sk と yazi の比較

| | sk (skim) | yazi |
|---|---|---|
| スタイル | fuzzy finder | TUIファイルマネージャー |
| 得意なこと | ファイル名での高速検索 | ディレクトリの視覚的なブラウジング |
| 操作感 | CLIネイティブ | GUIファイルマネージャーに近い |

---

## ライセンス

MIT
