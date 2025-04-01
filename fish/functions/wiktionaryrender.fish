function wiktionaryrender
    read -l -z str

    function label
        set tags $argv[2..]
        string join ', ' $tags
    end

    set templates \
        style "a|accent" (set_color red) \
        style "s|sense" (set_color blue) \
        vargs "lb|lbl|label" label (set_color blue) \
        style "ng|non-gloss" (set_color green)

    set reset_style (set_color normal)
    set --global i 1
    function i++
        echo $i
        set i (math "$i + 1")
    end
    while test $i -lt (count $templates)
        set type $templates[(i++)]

        set pfrag $templates[(i++)]
        set pattern "{{(?:$pfrag)\\|((?:.|\\n)*?)}}"

        if test "$type" = vargs
            set fn $templates[(i++)]
            set style $templates[(i++)]
            while true
                set rtarget "{{VARGS_REPLACE_TARGET}}"
                set scratch (string replace -f -r $pattern $rtarget $str)
                # no match, continue
                if test "$status" -ne 0
                    break
                end
                set args (string match -g -r $pattern $str | string split "|")
                set rinner ($fn $args)
                set str (string replace $rtarget "$style$rinner$reset_style" $scratch | string collect)
            end
        else
            set style $templates[(i++)]
            set str (string replace -r -a $pattern "$style\$1$reset_style" $str | string collect)
        end
    end
    set --erase i

    echo $str
end
