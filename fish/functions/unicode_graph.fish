function unicode_graph
    set bar_unicode _ '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█'
    set quantize 9

    set max (math "max($(string join ',' $argv))")
    for v in $argv
        # set index (math --scale 0 "(100 * ($v / $max)) / (100 / ($quantize - 1)) + 1")
        set index (math --scale 0 "1 + (($quantize - 1) * $v) / $max")
        echo -n $bar_unicode[$index]
    end
    echo
end
