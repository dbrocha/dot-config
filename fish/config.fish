source ~/.config/fish/alias.fish
fish_add_path "/opt/homebrew/bin"

set fish_greeting

set -x PATH $PATH /opt/nvim-linux-x86_64/bin
set -x FZF_DEFAULT_OPTS "--style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"
set -x FZF_DEFAULT_COMMAND "find -P . -type f"
set -x FZF_COMPLETION_TRIGGER '~~'
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x EDITOR nvim
set -gx SHELL (which fish)

starship init fish | source
zoxide init fish | source
thefuck --alias | source

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
