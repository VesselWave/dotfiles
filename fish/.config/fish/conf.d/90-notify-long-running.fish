set -g LONG_RUNNING_SEC 600

set -g LONG_RUNNING_EXCLUDE \
    bun \
    claude \
    gemini \
    git-log \
    htop \
    less \
    man \
    nano \
    node \
    nvim \
    pi \
    screen \
    ssh \
    tmux \
    top \
    vi \
    vim

function notify_long_running --on-event fish_postexec
    command -q notify-send; or return

    set -l threshold (math $LONG_RUNNING_SEC x 1000)
    set -l last_cmd $argv[1]
    set -l cmd_name (string split -f 1 " " $last_cmd)

    if contains $cmd_name $LONG_RUNNING_EXCLUDE
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
