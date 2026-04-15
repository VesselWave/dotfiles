function sudonp --description 'Temporarily enable passwordless sudo for current user'
    set -l user (id -un)
    set -l override "/etc/sudoers.d/zzzzz-nopasswd-$user"
    set -l legacy "/etc/sudoers.d/zzzz-passwd-$user"

    if test (count $argv) -eq 0
        echo "Usage: sudonp on|off|status|run [cmd ...]" >&2
        return 1
    end

    switch $argv[1]
        case on
            if sudo test -f "$legacy"
                sudo rm -f "$legacy"
                or return 1
            end

            if sudo test -f "$override"
                echo "sudonp: already on ($override)"
                return 0
            end

            set -l tmp (mktemp)
            printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$user" > "$tmp"

            sudo visudo -cf "$tmp"
            or begin
                rm -f "$tmp"
                return 1
            end

            sudo install -o root -g root -m 0440 "$tmp" "$override"
            set -l install_status $status
            rm -f "$tmp"
            test $install_status -eq 0
            or return $install_status

            sudo visudo -c
            or begin
                echo "sudonp: full sudoers check failed; removing override" >&2
                sudo rm -f "$override"
                sudo visudo -c >/dev/null 2>&1
                return 1
            end

            sudo -k
            echo "sudonp: on ($override)"

        case off
            set -l changed 0

            if sudo test -f "$override"
                sudo rm -f "$override"
                or return 1
                set changed 1
            end

            if sudo test -f "$legacy"
                sudo rm -f "$legacy"
                or return 1
                set changed 1
            end

            if test $changed -eq 0
                echo "sudonp: already off"
                sudo -k
                return 0
            end

            sudo visudo -c
            or return 1

            sudo -k
            echo "sudonp: off"

        case status
            if sudo test -f "$override"
                echo "on  $override"
            else if sudo test -f "$legacy"
                echo "off legacy-conflict $legacy"
            else
                echo "off $override"
            end

        case run
            sudonp on
            or return 1

            set -e argv[1]

            if test (count $argv) -gt 0
                $argv
            else
                fish
            end
            set -l cmd_status $status

            sudonp off
            or return 1

            return $cmd_status

        case '*'
            echo "Usage: sudonp on|off|status|run [cmd ...]" >&2
            return 1
    end
end
