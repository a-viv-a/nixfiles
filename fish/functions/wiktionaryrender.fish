function wiktionaryrender
    set -x word $argv[1]
    set -x eword (string escape --style=regex "$word")
    read -l -z str

    set -x reset_style (set_color normal)

    set templates \
        liter "{{...}}" " ... " \
        liter "{{nb...}}" " ..." \
        style "a|accent" (set_color red) \
        dynfn "s|sense" parens (set_color -i) \
        dynfn "lb|lbl|label" label (set_color -id) \
        style "ng|non-gloss" (set_color -i) \
        dynfn ux ux (set_color -i cyan) \
        dynfn "quote-book|quote-journal|quote-text|quote-web" quote "" \
        dynfn "plural of" plural_of (set_color -i) \
        dynfun cap cap "" \
        dynfn w wikilink (set_color blue)

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
        # handle the weird _ for no comma, trim around lines
        set body (string split '\n' $tags | string trim | string join ', ' | string replace -a ', _,' '')
        echo "($prefix$body)"
    end

    function boldword
        string replace -iar "$eword" "$(set_color -o)\$0$reset_style" $argv | string join "\n"
    end

    function ux -a code
        # this is more complex
        if test "$code" != en
            set_color red
            echo $argv
            return
        end
        echo -e (boldword $argv[2])
    end

    function first
        for arg in $argv
            if test "$arg" != ""
                echo $arg
            end
        end
    end

    function quote
        for arg in $argv
            string match -rg '(?<key>\\w+)=(?<val>[\\S\\s]*)' $arg >/dev/null

            set "k_$key" (string split '\n' "$val" | string trim | string join " ")
        end
        # messing with the colors is to result in a "two color" replacement where the title is dim
        # but the quote is not. any reset is replaced with the overall replacement color, so we need
        # to maintain our partial color ourselves
        if test (string sub --length 2 "$k_author") = "w:"
            set k_author "$(set_color blue)\e$(wikilink (string sub -s 3 "$k_author"))$(set_color -d white)"
        end
        if set -q k_url
            set k_url "$(set_color blue)\e$(hyperlink (string replace -a " " "" "$k_url"))$(set_color -d white)"
        end
        set_color -d white
        echo -e "$(string join ", " $k_year $k_author $k_journal $k_url $k_title $k_work):$reset_style $(boldword (first "$k_text" "$k_passage"))"
    end

    function plural_of -a lang entry
        echo "plural of $entry"
    end

    function cap -a p append
        set b (string sub --length 1 "$p" | string upper)
        set r (string sub -s 2 "$p")
        echo "$b$r$append"
    end

    function wikilink -a page display lang
        if test -z "$display"
            set display "$page"
        end
        hyperlink "https://en.wikipedia.com/wiki/$(string escape --style=url "$page")" "$display"
    end

    set --global i 1
    function i++
        echo $i
        set i (math "$i + 1")
    end
    while test $i -lt (count $templates)
        set type $templates[(i++)]

        set pfrag $templates[(i++)]
        set pattern "{{(?:$pfrag)\\|([\\S\\s]*?)}}"

        if test "$type" = liter
            set replacement $templates[(i++)]
            set str (string replace -a "$pfrag" "$replacement" "$str" | string collect)
        else if test "$type" = style
            set style $templates[(i++)]
            set str (string replace -r -a $pattern "$style\$1$reset_style" $str | string collect)
        else
            set fn $templates[(i++)]
            set style $templates[(i++)]
            while true
                set rtarget "{{VARGS_REPLACE_TARGET}}"
                set scratch (string replace -f -r $pattern $rtarget $str)
                # no match, continue
                if test "$status" -ne 0
                    break
                end
                set args (string match -g -r $pattern $str | string join '\n' | string split "|")
                set rinner ($fn $args | string replace -a "$reset_style" "$reset_style$style" | string collect)
                set str (string replace $rtarget "$style$rinner$reset_style" $scratch | string collect)
            end
        end
    end
    set --erase i

    echo $str
end
