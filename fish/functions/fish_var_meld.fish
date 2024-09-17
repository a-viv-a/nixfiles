function fish_var_meld --description "use meld to diff, edit the template fish_functions and the current fish_functions"
    nix-shell -p meld --run "meld ~/nixos/fish/fish_variables ~/.config/fish/fish_variables"
end
