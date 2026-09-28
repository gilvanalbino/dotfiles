# dotfiles

Minhas configurações pessoais. Cada ferramenta tem sua pasta com um `install.sh`.

As configs antigas de vim e fish (até 2020) estão no histórico: `git show 31bf3dd:vimrc/vimrc`.

```sh
git clone git@github.com:gilvanalbino/dotfiles.git ~/dotfiles
~/dotfiles/tmux/install.sh
```

## tmux

`tmux/install.sh` instala o tmux (via apt, se faltar), cria o symlink
`~/.tmux.conf` → `~/dotfiles/tmux/tmux.conf` (com backup de um arquivo existente),
clona o [TPM](https://github.com/tmux-plugins/tpm) e instala os plugins do `tmux.conf`.

Plugins opcionais usam `fzf` (tmux-fzf) e `htop` (popup em `prefix + Ctrl+h`).

Como `~/.tmux.conf` é um symlink, edições já caem no repositório: basta commitar e dar push.
Em outra máquina: `git -C ~/dotfiles pull` e `prefix + r` para recarregar.
Plugin novo: adicione `set -g @plugin '...'` e rode `prefix + I`.
