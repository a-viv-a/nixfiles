{
  description = "An example of a configured misterio77/nix-starter-config for impermanence";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    rustbin-flake.url = "path:rustbin";

    secrets-nix = {
      url = "git+ssh://git@github.com/a-viv-a/secrets_nix?shallow=1&ref=main";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      impermanence,
      home-manager,
      nix-index-database,
      sops-nix,
      rustbin-flake,
      ...
    }:
    {
      nixosConfigurations = {
        blade =
          let
            system = "x86_64-linux";
            rustbin = rustbin-flake.packages.${system};
          in
          nixpkgs.lib.nixosSystem {
            system = system;

            # Pass inputs into the NixOS module system
            specialArgs = {
              inherit inputs;
              inherit rustbin;
            };

            modules = [
              impermanence.nixosModules.impermanence
              ./configuration.nix
              ./greetd.nix
              ./wm.nix
              ./dict.nix
              # ./sync.nix
              ./laptop.nix

              nix-index-database.nixosModules.nix-index
              { programs.nix-index-database.comma.enable = true; }

              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = { inherit rustbin; };
              }
              sops-nix.nixosModules.sops
              {
                home-manager.verbose = true;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.aviva = import ./home.nix;
              }
            ];
          };
      };
    };
}
