function use --description "open nix-shell with packages"
    # risks TOCTOU but better than not attempting to validate
    if nix-shell --log-format bar-with-logs --packages $argv --run "echo packages cached, opening shell"
        exec nix-shell --quiet --packages $argv --run "export SHELL=$SHELL; exec $SHELL"
    else
        echo "failed to cache packages, aborting exec"
    end
end
