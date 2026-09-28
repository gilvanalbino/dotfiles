#!/bin/bash
# Liga ~/.tmux.conf a este repositório e instala os plugins via TPM.
# Pode ser executado várias vezes sem efeito colateral.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$HOME/.tmux.conf"
TPM="$HOME/.tmux/plugins/tpm"

if ! [ -x "$(command -v tmux)" ]; then
    echo "Installing tmux"
    sudo apt install -y tmux
fi

# Symlink (não cópia), para que edições locais já caiam no repositório
if [ -L "$CONF" ] && [ "$(readlink "$CONF")" = "$DIR/tmux.conf" ]; then
    echo "ok       $CONF"
else
    if [ -e "$CONF" ] || [ -L "$CONF" ]; then
        BACKUP="$CONF.bak.$(date +%Y%m%d%H%M%S)"
        mv "$CONF" "$BACKUP"
        echo "backup   $CONF -> $BACKUP"
    fi
    ln -s "$DIR/tmux.conf" "$CONF"
    echo "link     $CONF -> $DIR/tmux.conf"
fi

# Install the tmux plugin manager
if [ ! -d "$TPM" ]; then
    echo "Installing tmux plugin manager"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi
"$TPM/bin/install_plugins"

if [ -n "${TMUX:-}" ]; then
    tmux source-file "$CONF"
    echo "config do tmux recarregada"
fi
