{
  description = "Master flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwl = {
      url = "github:Shringe/dwl";
    };

    nf = {
      url = "github:Shringe/nf";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    nix-gaming.url = "github:fufexan/nix-gaming";

    disko = {
      url = "github:nix-community/disko";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-old, ... }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        inputs.nur.overlays.default
        inputs.dwl.overlays.default

        (self: super: {
          # dwl = inputs.dwl.packages.${system}.default;
          nf = inputs.nf.packages.${system}.default;

          mpv = super.mpv.override {
            scripts = with self.mpvScripts; [ 
              mpris 
              dynamic-crop
              thumbfast
              quack
            ];
          };
        })
      ];

      unstablePkgs = import nixpkgs-unstable {
        inherit system overlays;

        config.permittedInsecurePackages = [
          "jitsi-meet-1.0.8043"
        ];

        config.allowUnfree = true;
        # config.allowBroken = true;
      };

      stablePkgs = import nixpkgs {
        inherit system overlays;

        config.permittedInsecurePackages = [
          "jitsi-meet-1.0.8043"
        ];

        config.allowUnfree = true;
        # config.allowBroken = true;
      };

      oldPkgs = import nixpkgs-old {
        inherit system;
      };

      # Default pkgs
      pkgs = unstablePkgs;

      # No native optimizations, can be pulled from binary cache
      genericPkgs = unstablePkgs;
    in {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };

      nixosConfigurations = with nixpkgs.lib; {
        deity = 
          let 
            system = "x86_64-linux";
            arch = "znver3";
            abi = "64";

            optimize_builds = false;
          in 
            nixosSystem {
              specialArgs = { inherit system inputs; };
              modules = [ 
                {
                  nix.settings = {
                    system-features = [ "gccarch-${arch}" ];

                    # Makes it easier to tell which package failed to build with optimizations
                    max-jobs = mkIf optimize_builds 1;
                  };


                  nixpkgs = {
                    hostPlatform = {
                      system = system;
                      gcc = mkIf optimize_builds {
                        arch = arch;
                        tune = arch;
                        abi = abi;
                      };
                    };

                    overlays = mkIf optimize_builds [
                      (final: prev: {
                        postgresql_15 = genericPkgs.postgresql_15;
                        dotnetCorePackages = genericPkgs.dotnetCorePackages;

                        speexdsp = genericPkgs.speexdsp;
                        nototools = genericPkgs.nototools;
                        libsecret = genericPkgs.libsecret;
                        valkey = genericPkgs.valkey;
                        chromedriver = genericPkgs.chromedriver;
                        liberfa = genericPkgs.liberfa;

                        # It seems these pull in 32bit dependencies which really struggle to build
                        wine = genericPkgs.wine;
                        pipewire = genericPkgs.pipewire;
                        steam-run = genericPkgs.steam-run;
                        lutris = genericPkgs.lutris;


                        jellyfin-media-player = genericPkgs.jellyfin-media-player;
                        kdePackages = genericPkgs.kdePackages;
                        flaresolverr = genericPkgs.flaresolverr;
                        immich-machine-learning = genericPkgs.immich-machine-learning;
                        jdk17 = genericPkgs.jdk17;
                        jellyfin = genericPkgs.jellyfin;

                        libadwaita = prev.libadwaita.overrideAttrs (old: {
                          doCheck = false;
                        });

                        numpy = python-prev.numpy.overridePythonAttrs (oldAttrs: {
                          disabledTests = oldAttrs.disabledTests ++ ["test_umath_accuracy" "TestAccuracy::test_validate_transcendentals" "test_validate_transcendentals"];
                        });

                        python312 = prev.python312.override {
                          packageOverrides = pyfinal: pyprev: {
                            anyio = pyprev.anyio.overridePythonAttrs (oldAttrs: {
                              disabledTests = oldAttrs.disabledTests ++ [ "test_handshake_fail" ];
                            });
                          };
                        };
                      })
                    ];


                    config = {
                      allowUnfree = true;

                      # Cuda takes forever to build
                      cudaSupport = mkForce false;
                    };
                  };

                  # Ensure maximum build performance
                  powerManagement.cpuFreqGovernor = "performance";

                  environment.systemPackages = with pkgs; [
                    zellij
                  ];
                }

                inputs.determinate.nixosModules.default
                { # Determinate Nix settings
                  nix.settings = {
                    lazy-trees = true;
                  };
                }

                ./nixos/deity/configuration.nix 
                ./nixos/nixosModules
                ./shared
              ];
            };

        luminum = nixosSystem {
          specialArgs = { inherit system inputs pkgs stablePkgs unstablePkgs oldPkgs; };
          modules = [ 
            ./nixos/luminum/configuration.nix 
            ./nixos/nixosModules
            ./shared
          ];
        };
      };

      homeConfigurations = with inputs.home-manager.lib; {
        shringed = homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs stablePkgs unstablePkgs; };
          modules = [ 
            ./home-manager/shringed/home.nix 
            ./home-manager/homeManagerModules
            inputs.nixvim.homeManagerModules.nixvim
            ./shared
          ];
        };

        shringe = homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs stablePkgs unstablePkgs; };
          modules = [ 
            ./home-manager/shringe/home.nix 
            ./home-manager/homeManagerModules
            inputs.nixvim.homeManagerModules.nixvim
            ./shared
          ];
        };
      };
    };
}
