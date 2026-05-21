if status is-interactive
    function sync_history --on-event fish_prompt
        history --merge
    end
end

set fish_greeting
set -gx EDITOR vim

set -l paths \
    /usr/local/go/bin \
    $HOME/go/bin \
    $HOME/apps/flutter/bin \
    $HOME/.npm-global/bin \
    $HOME/.local/bin

for p in $paths
    if test -d $p
        fish_add_path $p
    end
end

set -l nvm_node_dir $HOME/.nvm/versions/node
if test -d $nvm_node_dir
    set -l latest_node_bin (find $nvm_node_dir -mindepth 2 -maxdepth 2 -type d -name bin | sort -Vr | head -n 1)

    if test -n "$latest_node_bin"
        fish_add_path $latest_node_bin
    end
end

if test -d $HOME/.bun
    set -gx BUN_INSTALL $HOME/.bun
    fish_add_path $BUN_INSTALL/bin
end

alias cp='cp -i'
alias ll='ls -lah'
alias ls='ls -lah --color=always --group-directories-first'
alias mkdir='mkdir -p'
alias mv='mv -i'
alias ping='ping -c 5'
alias rm=' rm -I --preserve-root'

if command -q conda
    conda shell.fish hook | source
end

if command -q zoxide
    zoxide init fish | source
end
