function gtree --description "Git-aware tree view using fd and tree"
    argparse --ignore-unknown \
        'L/level=' \
        'd/dirs' \
        'a/all' \
        'h/help' \
        -- $argv
    or return

    if set -q _flag_help
        echo "Usage: gtree [OPTIONS] [PATH]"
        echo ""
        echo "Git-aware tree view using fd and tree"
        echo ""
        echo "Options:"
        echo "  -L, --level N    Max depth to display"
        echo "  -d, --dirs       Show directories only"
        echo "  -a, --all        Show all files (including ignored)"
        echo "  -h, --help       Show this help"
        echo ""
        echo "PATH defaults to current directory (.)"
        return 0
    end

    set -l path .
    if test (count $argv) -gt 0
        set path $argv[1]
    end

    if not test -e $path
        echo "gtree: $path: No such file or directory" >&2
        return 1
    end

    if not test -d $path
        echo "gtree: $path: Not a directory" >&2
        return 1
    end

    set -l type_flag --type f
    if set -q _flag_dirs
        set type_flag --type d
    end

    set -l fd_flags --hidden --exclude .git
    if set -q _flag_all
        set fd_flags --hidden --no-ignore
    end

    set -l depth_flags
    if set -q _flag_level
        set depth_flags --max-depth $_flag_level
    end

    fd $type_flag $fd_flags $depth_flags . $path | tree --fromfile
end
