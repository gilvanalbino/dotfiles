#!/bin/bash
# Liga ~/.config/tmux/tmux.conf a este repositório e instala os plugins via TPM.
# Funciona no Omarchy (Arch) e em outros sistemas (apt, dnf, brew).
# Pode ser executado várias vezes sem efeito colateral.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$DIR/tmux.conf"
CONF="$HOME/.config/tmux/tmux.conf"
LEGACY="$HOME/.tmux.conf"
TPM="$HOME/.tmux/plugins/tpm"
STAMP="$(date +%Y%m%d%H%M%S)"

install_pkg() {
    if command -v pacman >/dev/null; then
        sudo pacman -S --needed --noconfirm "$@"
    elif command -v apt-get >/dev/null; then
        sudo apt-get install -y "$@"
    elif command -v dnf >/dev/null; then
        sudo dnf install -y "$@"
    elif command -v brew >/dev/null; then
        brew install "$@"
    else
        echo "Instale manualmente: $*" >&2
        return 1
    fi
}

# Aponta $1 para o tmux.conf do repositório, fazendo backup do que existir lá
link_conf() {
    local target="$1"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$SRC" ]; then
        echo "ok       $target"
        return
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "$target.bak.$STAMP"
        echo "backup   $target -> $target.bak.$STAMP"
    fi
    mkdir -p "$(dirname "$target")"
    ln -s "$SRC" "$target"
    echo "link     $target -> $SRC"
}

if ! command -v tmux >/dev/null; then
    echo "Installing tmux"
    install_pkg tmux
fi
command -v git >/dev/null || install_pkg git

# tmux >= 3.1 lê ~/.config/tmux/tmux.conf, mas também carrega ~/.tmux.conf se existir,
# o que misturaria duas configs. Versões antigas só leem ~/.tmux.conf.
link_conf "$CONF"
version="$(tmux -V | sed -E 's/[^0-9]*([0-9]+)\.([0-9]+).*/\1 \2/')"
read -r major minor <<<"$version"
if [ "$major" -gt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -ge 1 ]; }; then
    if [ -e "$LEGACY" ] || [ -L "$LEGACY" ]; then
        mv "$LEGACY" "$LEGACY.bak.$STAMP"
        echo "backup   $LEGACY -> $LEGACY.bak.$STAMP"
    fi
else
    link_conf "$LEGACY"
fi

# Install the tmux plugin manager
if [ ! -d "$TPM" ]; then
    echo "Installing tmux plugin manager"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi
"$TPM/bin/install_plugins"

command -v fzf >/dev/null || echo "aviso    fzf não encontrado (usado pelo tmux-fzf, prefix + F)"
command -v htop >/dev/null || echo "aviso    htop não encontrado (usado pelo popup em prefix + Ctrl+h)"

if [ -n "${TMUX:-}" ]; then
    tmux source-file "$CONF"
    echo "config do tmux recarregada"
fi
