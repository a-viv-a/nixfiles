function hyperlink -a url text
    set_color -u
    if test -z "$text"
        set text "$url"
    end
    echo -en "\e]8;;$url\a$text\e]8;;\a"
    set_color normal
end
