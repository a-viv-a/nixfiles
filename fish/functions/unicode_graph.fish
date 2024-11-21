function unicode_graph
    argparse --min-args=1 \
        'h/min_height=?!argparse_regex "\d+" "a positive whole number"' \
        -- $argv
    or return

    set bar_unicode '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█'
    set quantize 8

    set -q _flag_min_height; or set _flag_min_height 0

    set max (math "max($(string join ',' $argv), $_flag_min_height)")
    if test "$max" -eq 0
        for v in $argv
            echo -n $bar_unicode[1]
        end
    else
        for v in $argv
            # set index (math --scale 0 "(100 * ($v / $max)) / (100 / ($quantize - 1)) + 1")
            set index (math --scale 0 "1 + (($quantize - 1) * $v) / $max")
            echo -n $bar_unicode[$index]
        end
    end
    echo
end
