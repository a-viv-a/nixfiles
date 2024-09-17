{
  description = "An example of a configured misterio77/nix-starter-config for impermanence";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

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
      sops-nix,
      ...
    }:
    {
      nixosConfigurations = {
        blade = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # Pass inputs into the NixOS module system
          specialArgs = {
            inherit inputs;
          };

          modules = [
            impermanence.nixosModules.impermanence
            ./configuration.nix
            ./greetd.nix
            ./wm.nix
            ./sync.nix
            ./laptop.nix
            home-manager.nixosModules.home-manager
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
