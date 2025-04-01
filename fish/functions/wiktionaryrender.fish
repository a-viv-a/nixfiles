function wiktionaryrender
    read -l -z str

    set templates \
        "a|accent" (set_color red) \
        "s|sense" (set_color blue) \
        "lb|label" (set_color blue) \
        "ng|non-gloss" (set_color green)

    set reset_color (set_color normal)
    for i in (seq 1 2 (count $templates))
        set pfrag $templates[$i]
        set pattern "{{(?:$pfrag)\\|((?:.|\\n)*?)}}"
        set color $templates[(math "$i + 1")]
        set str (string replace -r -a $pattern "$color\$1$reset_color" $str | string collect)
        echo $pattern
    end

    echo $str
end
