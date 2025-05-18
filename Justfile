build ARG:
    nix build .#{{ ARG }}

lock ARG:
    nix run .#{{ ARG }}.lock
