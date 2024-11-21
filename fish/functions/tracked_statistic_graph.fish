function tracked_statistic_graph
    argparse --min-args=1 \
        'k/key=!argparse_regex "[a-z]+" "a lowercase alpha string"' \
        'h/min_height=?!argparse_regex "\d+" "a positive whole number"' \
        'w/width=!argparse_regex "\d+" "a positive whole number"' \
        -- $argv
    or return
    if test -z "$_flag_key" -o -z "$_flag_width"
        echo 'flag key, width is required'
        return 1
    end
    set data "_track_stat_$_flag_key""_data"

    set --append --global $data $argv[1]

    while test (count $$data) -gt $_flag_width
        set --erase --global "$data"[1]
    end

    set -q _flag_min_height; and set -l min_height "--min_height=$_flag_min_height"

    unicode_graph $min_height $$data
end
