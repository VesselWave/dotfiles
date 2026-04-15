function gemini
    set -l last_check_file "$HOME/scripts/gemini_updater_last_check"
    set -l today (date "+%Y-%m-%d")

    if test -f "$last_check_file"
        set last_check (cat "$last_check_file")
    end

    if test "$last_check" != "$today"
        set -l update_check (npm outdated -g -p @google/gemini-cli)

        if test -n "$update_check"
            echo "Update found! Updating @google/gemini-cli..."
            npm update -g @google/gemini-cli
        end

        echo "$today" > "$last_check_file"
    end

    command gemini $argv
end
