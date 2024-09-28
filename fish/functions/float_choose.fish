function float_choose
    set tmp (mktemp -t float_choose.XXXXXXXX)
    foot -W 140x45 -a floating_foot yazi --chooser-file "$tmp"
    cat -- "$tmp"
    # true if file size greater than zero
    test -s "$tmp"
    set exists $status
    rm -f -- "$tmp"
    return $exists
end
