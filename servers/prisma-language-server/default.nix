{
  lib,
  config,
  dream2nix,
  ...
}:
let
  name = "prisma-language-server";
  version = "6.13.0";
  sha256 = "sha256-eI1BOHVthTVBDVdZbSpjsNm2TSsR4PfL9QUsa/0xgy0=";
in
{
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-json-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  deps =
    { nixpkgs, ... }:
    {
      inherit nixpkgs;
      inherit (nixpkgs)
        gnugrep
        stdenv
        typescript
        ;
    };

  nodejs-granular-v3 = {
    runBuild = false;
  };

  name = lib.mkForce name;
  version = lib.mkForce version;

  mkDerivation = {
    src =
      config.deps.nixpkgs.runCommand "${name}-src"
        {
          inherit (config.deps.nixpkgs)
            bash
            coreutils
            gnutar
            gzip
            ;
          srcTarball = builtins.fetchurl {
            url = "https://registry.npmjs.org/@prisma/language-server/-/language-server-${version}.tgz";
            sha256 = sha256;
          };
        }
        ''
          mkdir -p $out
          tar -xzf $srcTarball --strip-components=1 -C $out
          touch $out/.extracted
        '';
    # dontBuild = true;
    installPhase = ''
      chmod +x $out/bin/${name}
    '';

    postInstall = ''
      patchShebangs $out
    '';
  };
}
