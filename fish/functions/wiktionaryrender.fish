function wiktionaryrender -a word
    read -l -z str

    set templates \
        style "a|accent" (set_color red) \
        dynfn "s|sense" parens (set_color -i) \
        dynfn "lb|lbl|label" label (set_color -id) \
        style "ng|non-gloss" (set_color -i) \
        style ux (set_color red)

    function parens
        echo "($argv[1])"
    end

    function label
        set tags $argv[2..]
        set prefix ""
        if test \
                "$tags[1]" = chiefly -o \
                "$tags[1]" = "of a"
            set prefix "$tags[1] "
            set --erase tags[1]
        end
        echo "($prefix$(string join ', ' $tags))"
    end

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

        if test "$type" = dynfn
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
