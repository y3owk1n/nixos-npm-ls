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
      ...
    }:
    let
      makeDream2nixPkg =
        pkgPath: pkgs:
        dream2nix.lib.evalModules {
          packageSets.nixpkgs = pkgs;
          modules = [
            pkgPath
            {
              paths = {
                projectRoot = ./.;
                projectRootFile = "flake.nix";
                package = pkgPath;
              };
            }
          ];
        };

      eachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
      ];
    in
    {
      overlays = import ./overlays { inherit self; };

      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          prisma-language-server = makeDream2nixPkg ./servers/prisma-language-server pkgs;
          gh-actions-language-server = makeDream2nixPkg ./servers/gh-actions-language-server pkgs;
        }
      );
    };
}
