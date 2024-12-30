nix run github:nix-community/nixos-anywhere -- --flake "/nixdots#$1" --generate-hardware-config nixos-generate-config "./nixos/$1/hardware-configuration.nix" --target-host "nixos@$2" --copy-host-keys
