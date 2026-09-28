# dotfiles

Minhas configurações pessoais. Cada ferramenta tem sua pasta com um `install.sh`.

As configs antigas de vim e fish (até 2020) estão no histórico: `git show 31bf3dd:vimrc/vimrc`.

```sh
git clone git@github.com:gilvanalbino/dotfiles.git ~/dotfiles
~/dotfiles/tmux/install.sh
```

## tmux

A config parte da padrão do [Omarchy](https://omarchy.org) (prefix `Ctrl+Space`, com `Ctrl+b`
como alternativo; atalhos com `Alt`; copy mode vi; tema) e acrescenta plugins e popups.
Funciona no Omarchy e em outros sistemas.

`tmux/install.sh` instala o tmux se faltar (pacman, apt, dnf ou brew), cria o symlink
`~/.config/tmux/tmux.conf` → `~/dotfiles/tmux/tmux.conf` (com backup de um arquivo existente),
clona o [TPM](https://github.com/tmux-plugins/tpm) e instala os plugins do `tmux.conf`.
No tmux 3.1 ou mais novo, um `~/.tmux.conf` existente vai para backup, senão as duas configs
seriam carregadas juntas. Em versões mais antigas, que só leem esse arquivo, ele vira o symlink.

Plugins opcionais usam `fzf` (tmux-fzf, `prefix + F`) e `htop` (popup em `prefix + Ctrl+h`).

Como a config é um symlink, edições já caem no repositório: basta commitar e dar push.
Em outra máquina: `git -C ~/dotfiles pull` e `prefix + q` para recarregar.
Atalhos: `prefix + ?`. Plugin novo: adicione `set -g @plugin '...'` e rode `prefix + I`.
