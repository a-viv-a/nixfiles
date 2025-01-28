{ pkgs, lib, ... }:
let
  cursor = {
    pkg = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 40;
  };
in
{
  imports = [ ./music.nix ];

  home = {
    username = "aviva";
    homeDirectory = "/home/aviva";
  };

  home.packages = with pkgs; [
    xclip
    tree
    ripgrep
    micro
    tealdeer
    bat
    fd
    foot
    fzf
    fuzzel
    obsidian
    rivercarro
    gparted
    yazi
    sioyek
    mosh
    usbutils
    killall
    age
    sops
    nodejs
    halloy
    inkscape
    watchexec

    # https://discourse.nixos.org/t/google-chrome-not-working-after-recent-nixos-rebuild/43746/8
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--profile-directory=Default"
        # fix chromecast, use avahi
        "--load-media-router-component-extension=1"
      ];
    })
    # https://github.com/Vencord/Vesktop/issues/516
    (vesktop.override { withSystemVencord = false; })
    spotify
  ];

  programs = {
    # home-manager.enable = true;

    fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "tide";
          src = tide.src;
        }
        {
          name = "fzf.fish";
          src = fzf-fish.src;
        }
      ];
      shellInit = ''
        fzf_configure_bindings
        direnv hook fish | source
      '';
      shellAbbrs = {
        cat = "bat";
        s = "sudo";
        y = "yazi";
        h = "hx";
        ts = "tailscale";
      };
      # shellAliases = with pkgs; builtins.mapAttrs (name: value: lib.getExe value){
      # 	cat = bat;
      # };
    };

    git = {
      enable = true;
      userEmail = "aviva@rubenfamily.com";
      userName = "Aviva Ruben";
      extraConfig = {
        safe.directory = "*";
        init.defaultBranch = "main";
        diff.sopsdiffer.textconv = "${pkgs.sops}/bin/sops decrypt";
      };
      aliases = {
        # based on James Munns alias: https://bsky.app/profile/jamesmunns.com/post/3l64jdcxl3727
        # prob not the original lol
        lg = "log --color --graph --pretty=format:'%Cred%h %Cgreen%>(9,trunc)%ar %C(bold blue)%<(12,trunc)%an%Creset - %s%C(auto)%+d' --abbrev-commit --";
        lgf = "log --color --graph --pretty=format:'%Cred%h %Cgreen%>(9,trunc)%ar %C(bold blue)%<(12,trunc)%an%Creset - %C(cyan)%s%C(auto)%+d%+b' --abbrev-commit --";
        lgm = "log --color --graph --pretty=format:'%Cred%h%Creset %<|(50,trunc)%s%C(auto)%+d' --abbrev-commit --";
      };
    };

    zoxide = {
      enable = true;
      options = [ "--cmd c" ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "dark_plus_plus";
        editor = {
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          shell = [
            (lib.getExe pkgs.fish)
            "-c"
          ];
          auto-save.focus-lost = true;
          lsp.display-inlay-hints = true;
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
        }
      ];
      themes = {
        dark_plus_plus = {
          "inherits" = "dark_plus";
          # "ui.background" = { };
        };
      };
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".icons/default".source = "${cursor.pkg}/share/icons/${cursor.name}";
  gtk.cursorTheme = {
    size = cursor.size;
    package = cursor.pkg;
    name = cursor.name;
  };

  # bring fish functions along
  # i like having them in their own files for highlighting ect
  xdg.configFile."fish/functions" = {
    source = ./fish/functions;
    recursive = true;
  };
  # completions
  xdg.configFile."fish/completions" = {
    source = ./fish/completions;
    recursive = true;
  };

  # restore fish_variables to match the template, destroying whatever is there
  # this is fine because it would be destroyed on reboot anyway
  # this allows configuring stuff without shell startup time, but is gross
  home.activation.templateFishVariables = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run cp --remove-destination --no-preserve=mode \
    	${builtins.toPath ./fish/fish_variables} ~/.config/fish/fish_variables
  '';

  # river and sandbar config
  xdg.configFile."river" = {
    source = ./river;
    recursive = true;
  };

  # fuzzel config
  xdg.configFile."fuzzel/fuzzel.ini".source = ./fuzzel/fuzzel.ini;

  # foot config
  xdg.configFile."foot/foot.ini".source = ./foot/foot.ini;

  xdg.configFile."halloy/config.toml".source = ./halloy/config.toml;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  xdg.configFile."nix/registry.json".source = ./templates/registry.json;

  # virt manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # ssh config
  programs.ssh = {
    # enable config via HM, not enabling ssh connection
    enable = true;
    matchBlocks = {
      "uwcs" = {
        hostname = "best-linux.cs.wisc.edu";
        user = "iruben";
      };
      "beige" = {
        hostname = "192.168.1.1";
        user = "root";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
