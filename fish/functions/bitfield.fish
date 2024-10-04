function bitfield --description "convert a list of numbers into a 32 bit bitfield, for use with river"
    set out 0
    # use bitor instead of + in case of repeats
    set operator bitor
    if test "$argv[1]" = "!"
        # we should consider caching this...
        set out (bitfield (seq 1 32))
        # remove the bang
        set -e argv[1]
        # use bitxor to remove the listed bits
        set operator bitxor
    end
    for n in $argv
        set out (math "$operator($out, 2 ^ ($n - 1))")
    end
    echo $out
end
