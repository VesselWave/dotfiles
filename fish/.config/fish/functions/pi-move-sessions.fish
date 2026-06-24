function pi-move-sessions --description 'Move pi session bucket from one cwd to another'
    set -l usage 'Usage: pi-move-sessions OLD_CWD NEW_CWD [--yes]'

    set -l do_it 0
    set -l positionals

    for arg in $argv
        switch "$arg"
            case --yes
                set do_it 1
            case -h --help help
                echo $usage
                echo
                echo 'Example:'
                echo '  pi-move-sessions ~/websites/devin-sons-plumbing ~/repos/websites/devin-sons-plumbing --yes'
                return 0
            case '*'
                set -a positionals "$arg"
        end
    end

    if test (count $positionals) -ne 2
        echo $usage >&2
        return 1
    end

    set -l old_cwd (path resolve -- $positionals[1])
    set -l new_cwd (path resolve -- $positionals[2])

    set -l old_safe (string replace -a ':' '-' -- (string replace -a '/' '-' -- (string trim -l -c '/' -- "$old_cwd")))
    set -l new_safe (string replace -a ':' '-' -- (string replace -a '/' '-' -- (string trim -l -c '/' -- "$new_cwd")))

    set -l old_store "$HOME/.pi/agent/sessions/--$old_safe--"
    set -l new_store "$HOME/.pi/agent/sessions/--$new_safe--"
    set -l stamp (date +%Y%m%d-%H%M%S)
    set -l backup "$old_store.bak.$stamp"

    if not test -d "$old_store"
        echo "Old session dir missing: $old_store" >&2
        return 1
    end

    mkdir -p "$new_store"

    set -l files $old_store/*.jsonl
    if not test -e "$files[1]"
        echo "No session files in: $old_store" >&2
        return 1
    end

    echo "old cwd:   $old_cwd"
    echo "new cwd:   $new_cwd"
    echo "old store: $old_store"
    echo "new store: $new_store"
    echo "backup:    $backup"
    echo "files:     "(count $files)

    if test $do_it -ne 1
        echo
        echo 'Dry run. Add --yes to apply.'
        return 0
    end

    cp -a "$old_store" "$backup"; or return 1
    mv $files "$new_store/"; or return 1

    perl -0pi -e "s#\Q$old_cwd\E#$new_cwd#g; s#\Q--$old_safe--\E#--$new_safe--#g;" "$new_store"/*.jsonl
    or return 1

    rmdir "$old_store" ^/dev/null

    echo
    echo 'Done.'
    echo 'Next:'
    echo "  cd $new_cwd"
    echo '  pi'
    echo '  /resume'
end
