function agy
    set -l last_check_file "$HOME/scripts/agy_updater_last_check"
    set -l today (date "+%Y-%m-%d")
    set -l last_check ""

    if test -f "$last_check_file"
        set last_check (cat "$last_check_file")
    end

    if test "$last_check" != "$today"
        command agy update
        mkdir -p (dirname "$last_check_file")
        echo "$today" > "$last_check_file"
    end

    command agy --dangerously-skip-permissions $argv
end
