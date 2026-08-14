function wire
    set repo ~/repos/wire-proxy-docker
    set conf_dir $repo/wg-client/wg_confs
    set dest $conf_dir/wg0.conf
    set last $repo/.wire-last-conf
    set compose_cmd sudo docker compose --project-directory $repo -f $repo/compose.yaml

    if test (count $argv) -eq 0
        if not test -f $last
            echo "Usage: wire /path/to/AirVPN.conf"
            echo "   or: wire [up|down|logs|restart|...]"
            return 1
        end

        set conf (string collect < $last)
        if not test -f "$conf"
            echo "wire: saved config not found: $conf"
            echo "wire: run again with: wire /path/to/AirVPN.conf"
            return 1
        end

        mkdir -p $conf_dir
        cp "$conf" $dest
        chmod 600 $dest 2>/dev/null
        $compose_cmd up -d
        mullvad-browser about:preferences &>/dev/null &
        disown
        return
    end

    if test -f "$argv[1]"
        set conf "$argv[1]"
        mkdir -p $conf_dir
        cp "$conf" $dest
        chmod 600 $dest 2>/dev/null
        printf '%s\n' "$conf" > $last
        $compose_cmd up -d
        mullvad-browser about:preferences &>/dev/null &
        disown
        return
    end

    switch "$argv[1]"
        case up
            $compose_cmd up -d
            mullvad-browser about:preferences &>/dev/null &
            disown
        case down
            $compose_cmd down
            mullvad-browser about:preferences &>/dev/null &
            disown
        case '*'
            $compose_cmd $argv
    end
end
