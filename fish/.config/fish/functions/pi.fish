function pi
    set -l py /home/user/scripts/pi

    switch "$argv[1]"
        case cd
            set -l target ($py cd $argv[2])
            or return 1
            cd "$target"
            printf '%s\n' "$target"
            return
        case resume
            set -l target ($py cd $argv[2])
            or return 1
            cd "$target"
            $py resume $argv[2]
            return $status
        case last
            set -l target ($py cd)
            or return 1
            cd "$target"
            $py last
            return $status
        case '*'
            $py $argv
            return $status
    end
end
