#!/bin/bash
# macOS 上的整套环境一键安装：平铺桌面 fantastic-i3（yabai + skhd + SketchyBar，单独的仓库 fantastic-i3-app，用 brew 装），
# 加上这里的小工具和 tmux 配置。可以重复运行：已经做好的步骤会跳过。
# 跑法：
#   新电脑上一行就够（会装 Homebrew，再把仓库克隆到 ~/.local/share/fantastic-i3-macOS）：
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mejistus/fantastic-i3-macOS/main/install.sh)"
#   已经克隆了：bash <仓库>/install.sh（fantastic-i3 里它是子模块 macos/，就是 bash <fantastic-i3>/macos/install.sh）
#
# 做的事：
#   1. 检查 Apple Silicon；没有 Homebrew 就用官方脚本装（会问开机密码，顺带装 Xcode 命令行工具）
#   2. 用 curl 跑的：把仓库克隆到 ~/.local/share/fantastic-i3-macOS（看不见的地方）。已经克隆了的放在哪里都行
#   3. bin/ 里的小工具每个链到 ~/.local/bin；在 fantastic-i3 里运行时，把它的 tmux 配置（../tmux，Linux 和 macOS 共用）
#      链到 ~/.config/tmux
#   4. 平铺桌面：已经接好了（~/.config/yabai 链到某一份 fantastic-i3，brew 装的或自己克隆的）就用那一份再 setup 一遍；
#      没有就 brew install mejistus/mona/fantastic-i3，再 fantastic-i3 setup（最后列出还要手动做的事和快捷键表）
set -euo pipefail

CLONE_DIR="$HOME/.local/share/fantastic-i3-macOS"   # 用 curl 跑时克隆到这里
REPO_URL="https://github.com/mejistus/fantastic-i3-macOS"

ok() { echo "✓ $*"; }
die() { echo "✗ $*" >&2; exit 1; }

# ---- 1. 前提 ----
[ "$(uname -s)" = Darwin ] || die "只支持 macOS"
[ "$(uname -m)" = arm64 ] || die "只支持 Apple Silicon"
if [ ! -x /opt/homebrew/bin/brew ]; then
    echo "→ 安装 Homebrew（官方脚本，会问开机密码，顺带装 Xcode 命令行工具，要等几分钟）"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [ -x /opt/homebrew/bin/brew ] || die "Homebrew 没装上，见上面的输出；也可以按 https://brew.sh 手动装好，再运行一次本脚本"
fi
if ! command -v brew >/dev/null 2>&1 && ! grep -qs 'brew shellenv' "$HOME/.zprofile"; then
    # 新开的终端里也能用 brew（Homebrew 装完让你自己加的就是这一行）
    printf '\neval "$(/opt/homebrew/bin/brew shellenv)"\n' >>"$HOME/.zprofile"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
ok "Apple Silicon、Homebrew"

# ---- 2. 仓库位置 ----
self=${BASH_SOURCE[0]:-}
if [ -n "$self" ] && [ -x "$(dirname "$self")/bin/center-window" ]; then
    REPO=$(cd "$(dirname "$self")" && pwd -P)
else
    # 用 curl 跑的：手里只有这个脚本，克隆仓库，再用仓库里的这个脚本接着装
    if [ ! -x "$CLONE_DIR/bin/center-window" ]; then
        if [ -e "$CLONE_DIR" ] || [ -L "$CLONE_DIR" ]; then
            die "$CLONE_DIR 已经存在，但不是这个仓库：移走它，再运行一次"
        fi
        echo "→ 克隆 $REPO_URL 到 $CLONE_DIR"
        mkdir -p "$(dirname "$CLONE_DIR")"
        git clone "$REPO_URL" "$CLONE_DIR"
    fi
    exec /bin/bash "$CLONE_DIR/install.sh" "$@"
fi
ok "仓库：$REPO"

# ---- 3. 小工具和 tmux ----
link() { # <仓库里的文件夹或文件> <链接位置>
    local src=$1 dst=$2
    if [ "$(readlink "$dst" 2>/dev/null)" != "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        if [ -L "$dst" ] && { [ ! -e "$dst" ] || [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; }; then
            rm "$dst"   # 坏掉的链接，或者指向同一处、只是路径写法不同：直接换
        elif [ -e "$dst" ] || [ -L "$dst" ]; then
            mv "$dst" "$dst.bak-$(date +%Y%m%d-%H%M%S)"
            echo "  原来的 $dst 已备份"
        fi
        ln -s "$src" "$dst"
    fi
    ok "$dst → $src"
}
for tool in "$REPO"/bin/*; do link "$tool" "$HOME/.local/bin/$(basename "$tool")"; done
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "  把 ~/.local/bin 加进 PATH，终端里才能直接用这些命令" ;; esac
# tmux：设置在外层 fantastic-i3 仓库（../tmux，macOS 和 Linux 共用）；在 fantastic-i3 里运行（macos 是它的子模块）时才有
if [ -f "$REPO/../tmux/tmux.conf" ]; then
    link "$(cd "$REPO/../tmux" && pwd)" "$HOME/.config/tmux"
    if [ -e "$HOME/.tmux.conf" ]; then
        echo "  ~/.tmux.conf 也会被 tmux 读（先读它，再读 ~/.config/tmux/tmux.conf），里面的设置会混进来：确认不需要后删掉它"
    fi
fi

# ---- 4. 平铺桌面 ----
# ~/.config/yabai 是链到某一份 fantastic-i3 的 yabai 文件夹的链接，它旁边的 bin/fantastic-i3 就是那一份的命令
if [ -x "$HOME/.config/yabai/../bin/fantastic-i3" ]; then
    exec "$HOME/.config/yabai/../bin/fantastic-i3" setup
fi
brew list --formula fantastic-i3 >/dev/null 2>&1 || brew install mejistus/mona/fantastic-i3
exec "$(brew --prefix)/bin/fantastic-i3" setup
