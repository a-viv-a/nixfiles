{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      naersk,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
      in
      {
        # defaultPackage = naersk-lib.buildPackage ./.;
        packages.distsort = naersk-lib.buildPackage {
          pname = "distsort";
          src = ./.;
        };
        devShell =
          with pkgs;
          mkShell {
            buildInputs = [
              cargo
              rustc
              rustfmt
              pre-commit
              rustPackages.clippy
              rust-analyzer

              bacon
              just
              fastmod
            ];
            RUST_SRC_PATH = rustPlatform.rustLibSrc;
          };
      }
    );
}
