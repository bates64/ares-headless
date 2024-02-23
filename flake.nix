{
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          ares-headless = pkgs.callPackage ./package.nix {
            inherit self;
            stdenv = pkgs.clangStdenv;
          };
          default = ares-headless;
        };
      }
    );
}
