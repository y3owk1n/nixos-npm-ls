{
  description = "Nixos NPM Language Servers";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
  };

  outputs =
    {
      self,
      dream2nix,
      nixpkgs,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mkPackage =
            { pkgPath }:
            dream2nix.lib.evalModules {
              packageSets.nixpkgs = pkgs;
              modules = [
                (import pkgPath)
                {
                  paths = {
                    projectRoot = ./.;
                    projectRootFile = "flake.nix";
                    package = pkgPath;
                  };
                }
              ];
            };
        in
        {
          prisma-language-server = mkPackage {
            pkgPath = ./servers/prisma-language-server;
          };
          gh-actions-language-server = mkPackage {
            pkgPath = ./servers/gh-actions-language-server;
          };
        }
      );
    };
}
