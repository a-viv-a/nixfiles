function persist_display --description "emit and copy temporary way-display cfg.yaml into nixos so it isn't reset"
    way-displays -w
    cp -f ~/.config/way-displays/cfg.yaml ~/nixos/way-displays/cfg.yaml
    
end
