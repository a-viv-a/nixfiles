function nearby
    set selection (
        cat $WORDLIST \
            | distsort unstable (wl-paste --primary) \
            # tiebreak=index to prefer LD sort order
            | fzf -i +m --tiebreak=index --preview "wdict {}" --preview-window="right,80%,wrap,<60(wrap,up,45%)"
    )

    # only run wl-copy if something was selected (i.e. not if fzf was exited)
    if test "$status" -eq 0
        string trim (echo "$selection") | wl-copy
    end

    exit
end
