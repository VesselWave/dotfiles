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
        case clone
            if test (count $argv) -ne 2
                echo "Usage: pi clone <repo>" >&2
                return 2
            end

            set -l repo $argv[2]
            set -l name (string replace -r '/+$' '' -- "$repo" | string replace -r '^.*/' '' | string replace -r '\.git$' '')
            if test -z "$name"
                echo "Cannot determine repo name: $repo" >&2
                return 2
            end

            set -l target "$HOME/repos/$name"
            git clone "$repo" "$target"
            or return $status
            cd "$target"
            or return 1
            $py
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
