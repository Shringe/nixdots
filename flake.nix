{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nf.url = "github:Shringe/nf";
    whalecrab.url = "github:Shringe/whalecrab";
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
    nix-gaming.url = "github:fufexan/nix-gaming";
    disko.url = "github:nix-community/disko";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    wait-online = {
      url = "github:Shringe/wait-online";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    liberodark = {
      url = "github:liberodark/my-flakes";
      # inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwl = {
      url = "github:Shringe/dwl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-old,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        inputs.nur.overlays.default
        inputs.dwl.overlays.default
        inputs.whalecrab.overlay
        inputs.nix-minecraft.overlay

        # Large overlay sets
        (self: super: {
          old = import nixpkgs-old {
            inherit system;
            config.allowUnfree = true;
          };
        })

        # Customized builds
        (self: super: {
          nf = inputs.nf.packages.${system}.default;
          wait-online = inputs.wait-online.packages.${system}.default;
          torzu = inputs.liberodark.packages.${system}.torzu.overrideAttrs (old: {
            env.NIX_CFLAGS_COMPILE = "${old.env.NIX_CFLAGS_COMPILE} -Ofast -march=znver3 -mtune=znver3";
          });

          mpv = super.mpv.override {
            scripts = with self.mpvScripts; [
              mpris
              dynamic-crop
              thumbfast
              quack
            ];
          };
        })

        # # Frequently slow or unreliable builds
        # (self: super: {
        #   opencv = self.stable.opencv;
        #   jellyfin-media-player = self.stable.jellyfin-media-player;
        #   jellyfin-tui = self.stable.jellyfin-tui;
        #   jellyfin = self.stable.jellyfin;
        #   homepage-dashboard = self.stable.homepage-dashboard;
        #   lutris = self.stable.lutris;
        # })

        # Broken builds
        (self: super: {
          jellyfin = self.old.jellyfin;
          jellyfin-media-player = self.old.jellyfin-media-player;
          immich-machine-learning = self.old.immich-machine-learning;
          universal-android-debloater = self.old.universal-android-debloater;
          searxng = self.old.searxng;
        })
      ];

      pkgs = import nixpkgs pkgConfig;
      pkgConfig = {
        inherit system overlays;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "jitsi-meet-1.0.8043"
            "qtwebengine-5.15.19"
            "olm-3.2.16"
          ];
        };
      };

      mkNixos =
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [
            # Binary cache provided here
            # https://docs.determinate.systems/guides/advanced-installation#nixos
            inputs.determinate.nixosModules.default

            ./nixos/${name}/configuration.nix
            ./nixos/nixosModules
            ./shared

            {
              networking.hostName = name;
              nixpkgs = pkgConfig;
              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];

                substituters = [
                  "https://hyprland.cachix.org"
                  "https://install.determinate.systems"
                ];

                trusted-substituters = [
                  "https://hyprland.cachix.org"
                  "https://install.determinate.systems"
                ];

                trusted-public-keys = [
                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                  "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
                ];
              };
            }
          ];
        };

      mkHome =
        name:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/${name}/home.nix
            ./home-manager/homeManagerModules
            ./shared

            {
              programs.home-manager.enable = true;
              home = {
                username = name;
                homeDirectory = "/home/${name}";
              };
            }
          ];
        };
    in
    {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };

      nixosConfigurations = {
        deity = mkNixos "deity";
        luminum = mkNixos "luminum";
      };

      homeConfigurations = {
        shringe = mkHome "shringe";
        shringed = mkHome "shringed";
      };
    };
}
