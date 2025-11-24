function func_load --description "source fish functions and completions in ~/nixos/"
    for fn in ~/nixos/fish/functions/*.fish
        echo "source $fn"
        source $fn
    end
    for comp in ~/nixos/fish/completions/*.fish
        echo "source $comp"
        source $comp
    end
end
