if status is-interactive
    function sync_history --on-event fish_prompt
        history --merge
    end
end

set fish_greeting

for p in \
    /usr/local/go/bin \
    $HOME/go/bin \
    $HOME/.nvm/versions/node/v22.18.0/bin \
    $HOME/apps/flutter/bin \
    $HOME/.npm-global/bin \
    $HOME/.local/bin
    if test -d $p
        fish_add_path $p
    end
end

alias ll="ls -lah"
set -gx EDITOR vim

if command -q conda
    conda shell.fish hook | source
end

if command -q kiro
    string match -q "$TERM_PROGRAM" "kiro"; and . (kiro --locate-shell-integration-path fish)
end

if test -d $HOME/.bun
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
end

set -g LONG_RUNNING_SEC 600

function notify_long_running --on-event fish_postexec
    set -l threshold (math $LONG_RUNNING_SEC x 1000)
    set -l last_cmd $argv[1]
    set -l cmd_name (string split -f 1 " " $last_cmd)
    set -l excluded_cmds vim vi nvim nano less man ssh top htop tmux screen \
	    git-log gemini claude pi bun node

    if contains $cmd_name $excluded_cmds
        return
    end

    if test $CMD_DURATION -gt $threshold
        set -l time_secs (math -s1 $CMD_DURATION / 1000)

        if test $status -eq 0
            notify-send -u normal -i terminal \
                "Task Finished ($time_secs s)" \
                "$last_cmd"
        else
            notify-send -u critical -i error \
                "Task Failed ($time_secs s)" \
                "$last_cmd"
        end
    end
end
