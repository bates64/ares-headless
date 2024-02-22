{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  outputs =
    { nixpkgs, self }:
    {
      packages.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        {
          ares = pkgs.callPackage ./package.nix { inherit self; };
          default = self.packages.x86_64-linux.ares;
        };
    };
}
