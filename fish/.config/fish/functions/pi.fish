function pi
    set home (realpath ~)

    if test (pwd -P) = "$home"
        set dir ~/repos/test/work-(date +%Y-%m-%d-%H%M%S)
        mkdir -p $dir
        cd $dir
    end

    if set -q TMUX
        command pi $argv
        return
    end

    set cwd (pwd -P)
    set session_base (basename "$cwd")
    set session_slug (string replace -a -r '[^A-Za-z0-9]+' '-' -- $session_base)
    set session_slug (string trim -c '-' -- $session_slug)

    if test -z "$session_slug"
        set session_slug cwd
    end

    set session_hash (printf '%s' "$cwd" | sha1sum | cut -c1-8)
    set session_name "pi-$session_slug-$session_hash"
    set pi_cmd (string join ' ' -- command pi (string escape -- $argv))

    if tmux has-session -t $session_name 2>/dev/null
        tmux attach-session -t $session_name
    else
        tmux new-session -c "$cwd" -s $session_name "$pi_cmd; exec fish"
    end
end
