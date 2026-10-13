# fantastic-i3-macOS

[中文](README.zh-CN.md) · Part of [fantastic-i3](https://github.com/mejistus/fantastic-i3), my i3 setup for Linux

Small tools and configs for macOS. The i3-style tiling desktop (yabai + skhd + SketchyBar) moved to its own repo, [fantastic-i3-app](https://github.com/mejistus/fantastic-i3-app), and installs with Homebrew:

```sh
brew install mejistus/mona/fantastic-i3
fantastic-i3 setup
```

## One-line install

On Apple Silicon, one line installs everything, Homebrew and the tiling desktop above included, and clones this repo out of sight to `~/.local/share/fantastic-i3-macOS`:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mejistus/fantastic-i3-macOS/main/install.sh)"
```

From a clone, run `bash install.sh` in it instead. The script is safe to rerun. It:

1. Installs Homebrew if it's missing. It asks for your login password and also installs the Xcode command-line tools.
2. Links every command in [`bin/`](bin) into `~/.local/bin`. Run from inside [fantastic-i3](https://github.com/mejistus/fantastic-i3), it also links its shared tmux config (`../tmux`, used by Linux and macOS alike) to `~/.config/tmux`.
3. If the tiling desktop is already set up (from Homebrew or a clone), runs `setup` of that copy again; otherwise `brew install`, then `fantastic-i3 setup`. At the end it lists what's left to do by hand and prints a key cheat sheet.

## Files

| Path | What |
|---|---|
| [`install.sh`](install.sh) | The one-line installer |
| [`bin/center-window`](bin/center-window) | Centres the front window; the AeroSpace config calls it |
| [`bin/freemps`](bin/freemps) | Allocates a given amount of GPU memory on the MPS device with PyTorch, 8 GB by default |
| [`bin/list_brew_packages`](bin/list_brew_packages) | Homebrew formulae and casks by disk size |
| [`bin/nvim-opener.sh`](bin/nvim-opener.sh) | Opens a file in Neovim in kitty |
| [`kitty/`](kitty) | kitty terminal config |
| [`aerospace/`](aerospace) | AeroSpace config |

`kitty/` and `aerospace/` are standalone configs; the installer doesn't touch them. For Neovim use [NextVim](https://github.com/mejistus/NextVim).

## License

My own scripts and configs here are licensed under [GPL-3.0](LICENSE) or later. The kitty themes in `kitty/themes/` come from kitty-themes and keep their MIT license ([`kitty/themes/LICENSE.md`](kitty/themes/LICENSE.md)).
