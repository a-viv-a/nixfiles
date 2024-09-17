function func_load --description "source fish functions in ~/nixos/"
    for fn in ~/nixos/fish/functions/*.fish
        echo "source $fn"
        source $fn
    end
end
