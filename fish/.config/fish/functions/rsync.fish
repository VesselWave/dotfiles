function rsync --description 'Guardrail against rsync trailing slashes'
    set -l argc (count $argv)

    if test $argc -lt 2
        command rsync $argv
        return
    end

    for i in (seq 1 (math $argc - 1))
        set -l arg $argv[$i]

        if string match -q -- "-*" $arg
            continue
        end

        if string match -q -r '/$' -- $arg; and test "$arg" != "/"
            echo "🛑 Error: Source path '$arg' has trailing slash." >&2
            echo "Trailing slash copies contents, not dir itself." >&2
            echo "Bypass: command rsync $argv" >&2
            return 1
        end
    end

    command rsync $argv
end
