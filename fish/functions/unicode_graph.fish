function unicode_graph
    argparse --min-args=1 \
        'h/min_height=?!string match -rq \'\d+\' "$_flag_value"' \
        -- $argv
    or return

    set bar_unicode _ '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█'
    set quantize 9

    set -q _flag_min_height || set _flag_min_height 0

    set max (math "max($(string join ',' $argv), $_flag_min_height)")
    for v in $argv
        # set index (math --scale 0 "(100 * ($v / $max)) / (100 / ($quantize - 1)) + 1")
        set index (math --scale 0 "1 + (($quantize - 1) * $v) / $max")
        echo -n $bar_unicode[$index]
    end
    echo
end
