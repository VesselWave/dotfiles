function copy --wraps='echo "file://$(realpath filename)" | wl-copy -t text/uri-list' --description 'Copy file as URI to clipboard'
    echo "file://$(realpath $argv)" | wl-copy -t text/uri-list
end
