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

    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
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

    swayosd_main_monitor = {
      url = "github:Shringe/swayosd_main_monitor";
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
      url = "github:nix-community/nixvim/nixos-25.11";
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
      # Possible options: "cpp" "lix" "detsys"
      nixDistribution = "detsys";

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
          swayosd_main_monitor = inputs.swayosd_main_monitor.packages.${system}.default;
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

        # Waiting for binary cache
        (self: super: {
          collabora-online = self.old.collabora-online;
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
      ]
      ++ nixpkgs.lib.optionals (nixDistribution == "lix") [
        # Use lix for supported tools
        (self: super: {
          inherit (super.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
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
            ./nixos/${name}/configuration.nix
            ./nixos/nixosModules
            ./shared

            {
              networking.hostName = name;
              nixpkgs = pkgConfig;
              documentation.enable = false; # Building docs is slow
              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];

                http-connections = 128;
                max-substitution-jobs = 128;

                substituters = [
                  "https://devenv.cachix.org?priority=12"
                  "https://nix-community.cachix.org?priority=3"
                  "https://hyprland.cachix.org?priority=4"
                  "https://nix-gaming.cachix.org?priority=5"
                  "https://walker.cachix.org?priority=6"
                  "https://walker-git.cachix.org?priority=8"
                  "https://cache.nixos-cuda.org?priority=10"
                ]
                ++ nixpkgs.lib.optionals (nixDistribution == "detsys") [
                  "https://install.determinate.systems?priority=2"
                ];

                trusted-public-keys = [
                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                  "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
                  "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
                  "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
                  "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
                ]
                ++ nixpkgs.lib.optionals (nixDistribution == "detsys") [
                  "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
                ];
              };
            }
          ]
          ++ nixpkgs.lib.optionals (nixDistribution == "detsys") [
            # Binary cache provided here
            # https://docs.determinate.systems/guides/advanced-installation#nixos
            inputs.determinate.nixosModules.default
            {
              nix.settings = {
                substituters = [
                  "https://install.determinate.systems?priority=2"
                ];
                trusted-public-keys = [
                  "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
                ];
              };
            }
          ]
          ++ nixpkgs.lib.optionals (nixDistribution == "lix") [
            {
              nix.package = pkgs.lixPackageSets.stable.lix;
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
