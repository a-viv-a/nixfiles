function helix_edit_primary
    set template 'helix_edit_primary.XXXXXXXX'
    set suffix (read -c '.' -P $template)
    if test $status -ne 0 -o -z "$suffix" -o "$suffix" = "."
        return 1
    end
    echo "$suffix"
    set tmp (mktemp -p ~/scratch -t $template --suffix=$suffix)
    set initial (wl-paste --primary | tee $tmp)
    hx $tmp
    if test "$initial" != "$(cat $tmp)"
        cat $tmp | wl-copy
        echo put contents of $tmp into clipboard
    end
end
