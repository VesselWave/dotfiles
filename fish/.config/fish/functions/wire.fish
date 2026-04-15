function wire
    set compose_cmd sudo docker compose --project-directory ~/repos/wire-proxy-docker -f ~/repos/wire-proxy-docker/compose.yaml

    if test (count $argv) -eq 0
        echo "Usage: wire [up|down|logs|restart|...]"
        return 1
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
