{
  description = "Master flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    dwl = {
      url = "github:Shringe/dwl";
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

        (self: super: {
          dwl = inputs.dwl.packages.${system}.default;

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
            cuda = true;

            enable_build_utilities = true;
            flake_directory = "/nixdots";
            editor = "nvim";
            shell = "fish";

            optimize_builds = true;
            skip_optimizing_broken_builds = true;
            skip_optimizing_32bit_builds = true;
            skip_optimizing_large_builds = true;
            disable_broken_tests = true;
            disable_excess_functionality = false;
          in 
            nixosSystem {
              specialArgs = { inherit system inputs; };
              modules = [ 
                {
                  nix.settings.system-features = [ "gccarch-${arch}" ];

                  nixpkgs = {
                    hostPlatform = {
                      system = system;
                      gcc = mkIf optimize_builds {
                        arch = arch;
                        tune = arch;
                        abi = abi;
                      };
                    };

                    overlays = overlays
                      ++ optionals (skip_optimizing_broken_builds) [
                        (final: prev: {
                          postgresql_15 = genericPkgs.postgresql_15;
                          dotnetCorePackages = genericPkgs.dotnetCorePackages;


                          # speexdsp = genericPkgs.speexdsp;
                          # nototools = genericPkgs.nototools;
                          # libsecret = genericPkgs.libsecret;
                          # valkey = genericPkgs.valkey;
                          # chromedriver = genericPkgs.chromedriver;
                          # liberfa = genericPkgs.liberfa;
                        })
                      ] ++ optionals (skip_optimizing_32bit_builds) [
                        (final: prev: {
                          # It seems these pull in 32bit dependencies which really struggle to build
                          wine = genericPkgs.wine;
                          pipewire = genericPkgs.pipewire;
                          steam-run = genericPkgs.steam-run;
                          lutris = genericPkgs.lutris;
                        })
                      ] ++ optionals (skip_optimizing_large_builds) [
                        (final: prev: {
                          # Mostly QtWebEngine
                          jellyfin-media-player = genericPkgs.jellyfin-media-player;
                          kdePackages = genericPkgs.kdePackages;
                          flaresolverr = genericPkgs.flaresolverr;
                          immich-machine-learning = genericPkgs.immich-machine-learning;
                          jdk17 = genericPkgs.jdk17;
                          jellyfin = genericPkgs.jellyfin;
                        })
                      ] ++ optionals (disable_broken_tests) [
                        (final: prev: {
                          libadwaita = prev.libadwaita.overrideAttrs (old: {
                            doCheck = false;
                          });
                        })
                      ];


                    config = {
                      allowUnfree = true;

                      # Cuda takes forever to build
                      cudaSupport = mkForce cuda;
                    };
                  };

                  # Ensure maximum build performance
                  powerManagement.cpuFreqGovernor = "performance";
                  # swapDevices = mkForce [ ];

                  environment.systemPackages = with pkgs; mkIf enable_build_utilities [
                    # For running the build in the backround
                    zellij

                    (writeShellApplication {
                      name = "optAnalyze";
                      runtimeInputs = [
                        gnugrep
                        gawk
                        procps
                        coreutils
                      ];

                      text = ''
                        function diskPercent {
                          df "/nix/store" | awk '$NF == "/nix/store" { match($(NF-1), /([0-9]+)%/, m); print m[1] }'
                        }

                        function memPercent {
                          free | awk '/Mem/{printf("RAM: %.0f%"), $3/$2*100} /buffers\/cache/{printf(", buffers: %.0f%"), $4/($3+$4)*100} /Swap/{printf("; swap: %.0f%"), $3/$2*100}'
                        }

                        function cpuPercent {
                          vmstat 1 2 | awk 'END { print 100 - $15 }'
                        }

                        function hardwareStats {
                          echo "Disk $(diskPercent)% || CPU $(cpuPercent)% || $(memPercent)"
                        }

                        function countGrep {
                          num=$(pgrep -af . | grep -- "$1" | grep -o -- "$1" | wc -l)
                          echo "Found $((num - 2)) processes building with \"$1\""
                        }

                        ftune="-mtune=${arch}"
                        fmarch="-march=${arch}"

                        tune="-mtune=generic"
                        march="-march=${system}"

                        opt2="-O2"
                        opt3="-O3"

                        hardwareStats
                        countGrep $ftune
                        countGrep $fmarch
                        countGrep $tune
                        countGrep $march
                        countGrep $opt2
                        countGrep $opt3
                      '';
                    })

                    (writeShellApplication {
                      name = "watchBuild";
                      runtimeInputs = [
                        zellij
                        gnugrep
                        coreutils
                        nh
                        lazygit
                      ];

                      text = ''
                        sessions=$(zellij list-sessions || echo "failed")
                        name="watchBuild"
                        layout="${writeText "watchBuildLayout" ''
                          layout {
                              default_tab_template {
                                  // the default zellij tab-bar and status bar plugins
                                  pane size=1 borderless=true {
                                      plugin location="zellij:tab-bar"
                                  }
                                  children
                                  pane size=1 borderless=true {
                                      plugin location="zellij:status-bar"
                                  }
                              }

                              tab split_direction="vertical" {
                                pane command="nh" {
                                  args "os" "switch"
                                }
                                pane size=60 split_direction="horizontal" {
                                  pane command="watch" {
                                    args "-n" "10" "optAnalyze"
                                  }
                                  pane command="${shell}"
                                }
                              }

                              tab cwd="${flake_directory}" {
                                pane command="${editor}" {
                                  args "flake.nix"
                                }
                              }

                              tab cwd="${flake_directory}" {
                                pane command="lazygit"
                              }

                              tab {
                                pane command="${shell}"
                              }
                          }
                        ''}"

                        if echo "$sessions" | grep -q "$name"; then
                          echo "Attaching to existing session"
                          zellij attach "$name"
                        else
                          echo "Creating new session"
                          zellij --session "$name" --new-session-with-layout "$layout"
                        fi
                      '';
                    })
                  ];

                  # Disable long or broken builds for now
                  nixosModules = mkIf disable_excess_functionality {
                    album.immich.enable = mkForce false;
                    social.jitsi.enable = mkForce false;
                    social.matrix.conduit.enable = mkForce false;
                    caldav.radicale.enable = mkForce false;

                    gaming = {
                      games.enable = mkForce false;
                      steam.enable = mkForce false;
                    };

                    openrgb.enable = mkForce false;

                    torrent.qbittorrent.enable = mkForce false;
                    arrs = {
                      lidarr.enable = mkForce false;
                      sonarr.enable = mkForce false;
                      prowlarr.enable = mkForce false;
                      radarr.enable = mkForce false;
                      flaresolverr.enable = mkForce false;
                      vpn.enable = mkForce false;
                    };

                    llm = {
                      ollama.enable = mkForce false;
                    };

                    docker = {
                      enable = mkForce false;
                      romm.enable = mkForce false;
                      ourshoppinglist.enable = mkForce false;
                    };

                    groceries.tandoor.enable = mkForce false;
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
