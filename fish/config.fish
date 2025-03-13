source ~/.config/fish/alias.fish

set fish_greeting

set -x PATH $PATH /opt/nvim-linux-x86_64/bin
set -x FZF_DEFAULT_OPTS "--style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"
set -x FZF_DEFAULT_COMMAND "find -P . -type f"
set -x FZF_COMPLETION_TRIGGER '~~'
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x EDITOR nvim
set -gx SHELL (which fish)

starship init fish | source

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
