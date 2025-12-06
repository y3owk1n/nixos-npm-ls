# NPM based Language Server in Nixos

> This flake exists because there's no easy way to install the NPM based language server (e.g. prismals) in Nixos, and we can't easily use mason.nvim in Nixos either.
> This repo is mainly for my own usage, but feel free to use it if you want.
> The packages will be removed once the upstream made them available and actually usable.

A self-updating (every 6 hours) Nix Flake that packages using [`dream2nix`](https://github.com/nix-community/dream2nix).
Useful for Neovim, editors, or developer tools that rely on Prisma language intelligence — all fully reproducible and Nix-native.

## 📦 Packages

- [`@prisma/language-server`](https://www.npmjs.com/package/@prisma/language-server)
- [`lttb/gh-actions-language-server`](https://www.npmjs.com/package/gh-actions-language-server)

## 🚀 Usage

### 📥 Install via Flake

> [!note]
> This is just an example, you can use this flake however it suits your configuration style.

First create or update your overlays setup. Your setup might be different than mine, but the concept should be the same.

```nix
# overlays.nix
{
  nixos-npm-ls,
  ...
}:
{
  nixpkgs.overlays = [
    nixos-npm-ls.overlays.default
    ... # your existing overlays
 ];
}
```

Then add the flake to your inputs, don't forget the overlays (again your setup might be different, do it your way).

```nix
# flake.nix
{
 inputs.nixos-npm-ls.url = "github:y3owk1n/nixos-npm-ls";

 outputs = { nixos-npm-ls, ... }: {
  nixosConfigurations.myComputer = pkgs.lib.nixosSystem {
   system = "x86_64-linux";
   modules = [
    ./overlays.nix
    ...
   ];
  };
 };
}
```

Then you can use it in your nixos or home manager configuration:

```nix
# configuration.nix
{
 environment.systemPackages = with pkgs; [
  prisma-language-server
  gh-actions-language-server
 ];
}

# or home manager
{
 home.packages = with pkgs; [
  prisma-language-server
  gh-actions-language-server
 ];
}
```

Then you can use them in your system, the binary should also match nvim lspconfig's binary name.
