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
            set -l pi_args $argv
            if test "$argv[1]" = update; and test (count $argv) -eq 1
                set pi_args update --all
            end

            $py $pi_args
            set -l st $status
            if test $st -eq 0; and test "$argv[1]" = update
                ~/scripts/pi-patch-package-update-age
            end
            return $st
    end
end
