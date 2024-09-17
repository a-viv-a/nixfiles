function pkgrepl --description "start a nix repl with nix pkgs loaded"
    nix repl --expr 'import <nixpkgs>{}'
end
