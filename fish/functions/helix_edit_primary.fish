function helix_edit_primary
    set template 'helix_edit_primary.XXXXXXXX'
    set tmp (mktemp -p ~/scratch -t $template --suffix=(read -c '.' -P $template))
    set initial (wl-paste --primary | tee $tmp)
    hx $tmp
    if test "$initial" != "$(cat $tmp)"
        cat $tmp | wl-copy
        echo put contents of $tmp into clipboard
    end
end
