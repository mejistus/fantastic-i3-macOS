# fantastic-i3-macOS

[English](README.md) · 属于 [fantastic-i3](https://github.com/mejistus/fantastic-i3/blob/main/README.zh-CN.md)，那边是 Linux 上的 i3 配置

macOS 上的小工具和配置。i3 风格的平铺桌面（yabai + skhd + SketchyBar）搬到了单独的仓库 [fantastic-i3-app](https://github.com/mejistus/fantastic-i3-app)，用 Homebrew 装：

```sh
brew install mejistus/mona/fantastic-i3
fantastic-i3 setup
```

## 一键安装

Apple Silicon 上一行装好全部（包括 Homebrew 和上面的平铺桌面），这个仓库会克隆到看不见的 `~/.local/share/fantastic-i3-macOS`：

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mejistus/fantastic-i3-macOS/main/install.sh)"
```

已经克隆了仓库，就在里面运行 `bash install.sh`。脚本可以重复运行，它会：

1. 没有 Homebrew 就装上。会问开机密码，顺带装好 Xcode 命令行工具。
2. 把 [`bin/`](bin) 里的每个命令链接到 `~/.local/bin`。在 [fantastic-i3](https://github.com/mejistus/fantastic-i3) 里运行时，还把它的 tmux 配置（`../tmux`，Linux 和 macOS 共用）链接到 `~/.config/tmux`。
3. 平铺桌面已经接好了（brew 装的或自己克隆的）就用那一份再 `setup` 一遍，没有就 `brew install` 再 `fantastic-i3 setup`。最后列出还要手动做的事，再打印一张快捷键表。

## 文件

| 路径 | 内容 |
|---|---|
| [`install.sh`](install.sh) | 一键安装 |
| [`bin/center-window`](bin/center-window) | 把最前面的窗口居中，AeroSpace 配置里用 |
| [`bin/freemps`](bin/freemps) | 用 PyTorch 在 MPS 上占用指定大小的显存，默认 8 GB |
| [`bin/list_brew_packages`](bin/list_brew_packages) | 按占用空间列出 Homebrew 装的包 |
| [`bin/nvim-opener.sh`](bin/nvim-opener.sh) | 在 kitty 里用 Neovim 打开文件 |
| [`kitty/`](kitty) | kitty 终端配置 |
| [`aerospace/`](aerospace) | AeroSpace 配置 |

`kitty/` 和 `aerospace/` 是独立的配置，安装脚本不碰它们。Neovim 配置用 [NextVim](https://github.com/mejistus/NextVim)。

## 许可证

这里我自己写的脚本和配置按 [GPL-3.0](LICENSE) 或更新的版本发布。`kitty/themes/` 里的 kitty 主题来自 kitty-themes，保留它的 MIT 许可证（[`kitty/themes/LICENSE.md`](kitty/themes/LICENSE.md)）。
