{
  description = "Master flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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
      unstablePkgs = import nixpkgs-unstable {
        inherit system;

        overlays = [
          inputs.nur.overlays.default

          (self: super: {
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

        config.permittedInsecurePackages = [
          "jitsi-meet-1.0.8043"
        ];

        config.allowUnfree = true;
        # config.allowBroken = true;
      };

      stablePkgs = import nixpkgs {
        inherit system;

        overlays = [
          inputs.nur.overlays.default

          (self: super: {
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
    in {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };

      nixosConfigurations = with nixpkgs.lib; {
        deity = nixosSystem {
          specialArgs = { inherit system inputs stablePkgs unstablePkgs oldPkgs; };
          modules = [ 
            {
              nix.settings.system-features = [ "gccarch-znver3" ];

              nixpkgs = {
                hostPlatform = {
                  system = "x86_64-linux";
                  gcc = {
                    arch = "znver3";
                    tune = "znver3";
                    abi = "64";
                  };
                };

                overlays = [
                  (final: prev: {
                    # Broken native builds
                    spidermonkey_91 = unstablePkgs.spidermonkey_91;
                    spidermonkey_115 = unstablePkgs.spidermonkey_115;
                    spidermonkey_128 = unstablePkgs.spidermonkey_128;
                    speexdsp = unstablePkgs.speexdsp;
                    nototools = unstablePkgs.nototools;
                    libsecret = unstablePkgs.libsecret;
                    valkey = unstablePkgs.valkey;
                    chromedriver = unstablePkgs.chromedriver;
                    dotnetCorePackages = unstablePkgs.dotnetCorePackages;
                    liberfa = unstablePkgs.liberfa;
                    immich-machine-learning = unstablePkgs.immich-machine-learning;
                    postgresql_15 = unstablePkgs.postgresql_15;

                    # It seems these pull in 32bit dependencies which really struggle to build
                    wine = unstablePkgs.wine;
                    pipewire = unstablePkgs.pipewire;
                    steam-run = unstablePkgs.steam-run;

                    # python312 = unstablePkgs.python312;
                    # python312 = prev.python312.override {
                    #   packageOverrides = pyFinal: pyPrev: {
                    #     numpy = unstablePkgs.python312Packages.numpy;
                    #   };
                    # };

                    # Take forever to compile
                    postgresql = unstablePkgs.postgresql;
                    gfortran = unstablePkgs.gfortran;
                    lutris = unstablePkgs.lutris;
                    xdg-desktop-portal-gtk = unstablePkgs.xdg-desktop-portal-gtk;
                    gparted = unstablePkgs.gparted;
                    ghc = unstablePkgs.ghc;
                    haskell = unstablePkgs.haskell;
                    nodejs_20 = unstablePkgs.nodejs_20;
                    nodejs_22 = unstablePkgs.nodejs_22;
                    nodejs_24 = unstablePkgs.nodejs_24;
                    nodejs-slim = unstablePkgs.nodejs-slim;
                    # vulkan-tools = unstablePkgs.vulkan-tools;
                    kdePackages = unstablePkgs.kdePackages;
                    libsForQt5 = unstablePkgs.libsForQt5;
                    udisks = unstablePkgs.udisks;
                    ranger = unstablePkgs.ranger;
                    jellyfin-web = unstablePkgs.jellyfin-web;
                    wine64 = unstablePkgs.wine64;
                    mpv = unstablePkgs.mpv;
                    discord = unstablePkgs.discord;
                    wlroots = unstablePkgs.wlroots;
                    wlroots_0_18 = unstablePkgs.wlroots_0_18;
                    libei = unstablePkgs.libei;
                    jdk = unstablePkgs.jdk;
                    orca = unstablePkgs.orca;
                    # rocmPackages = unstablePkgs.rocmPackages;
                    openblas = unstablePkgs.openblas;
                    prisma = unstablePkgs.prisma;
                    ffmpeg = unstablePkgs.ffmpeg;
                    flatpak = unstablePkgs.flatpak;
                    kavita = unstablePkgs.kavita;
                    adguardhome = unstablePkgs.adguardhome;
                    remarshal = unstablePkgs.remarshal;
                    remarshal_0_17 = unstablePkgs.remarshal_0_17;
                    gcr = unstablePkgs.gcr;
                    flac = unstablePkgs.flac;
                    zint = unstablePkgs.zint;
                    jellyseerr = unstablePkgs.jellyseerr;
                    noto-fonts-color-emoji = unstablePkgs.noto-fonts-color-emoji;
                    pinentry-qt = unstablePkgs.pinentry-qt;
                    chromium = unstablePkgs.chromium;
                    opencv = unstablePkgs.opencv;
                    redis = unstablePkgs.redis;
                  })
                ];

                config = {
                  allowUnfree = true;

                  # Cuda takes forever to build
                  # cudaSupport = mkForce false;
                };
              };

              # Ensure maximum build performance
              powerManagement.cpuFreqGovernor = "performance";
              swapDevices = mkForce [ ];

              environment.systemPackages = with pkgs; [
                # For running the build in the backround
                zellij

                (writeShellApplication {
                  name = "watchBuild";
                  runtimeInputs = [
                    zellij
                    gnugrep
                    coreutils
                    nh
                    # neovim
                    fish
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
                              pane command="fish"
                            }
                          }

                          tab cwd="/nixdots" {
                            pane command="nvim" {
                              args "flake.nix"
                            }
                          }

                          tab cwd="/nixdots" {
                            pane command="lazygit"
                          }

                          tab {
                            pane command="fish"
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

                # To make sure optimizations are being applied
                (writeShellApplication {
                  name = "optAnalyze";
                  runtimeInputs = [
                    gnugrep
                    gawk
                    procps
                    coreutils
                  ];

                  text = ''
                    ARCH="znver3"

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

                    ftune="-mtune=$ARCH"
                    fmarch="-march=$ARCH"

                    tune="-mtune=generic"
                    march="-march=x86"

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
              ];

              # Disable long or broken builds for now
              nixosModules = {
                # album.immich.enable = mkForce false;
                # social.jitsi.enable = mkForce false;
                # social.matrix.conduit.enable = mkForce false;
                # caldav.radicale.enable = mkForce false;

                gaming = {
                  # games.enable = mkForce false;
                  # steam.enable = mkForce false;
                };

                # openrgb.enable = mkForce false;

                # torrent.qbittorrent.enable = mkForce false;
                arrs = {
                  # lidarr.enable = mkForce false;
                  # sonarr.enable = mkForce false;
                  # prowlarr.enable = mkForce false;
                  # radarr.enable = mkForce false;
                  # flaresolverr.enable = mkForce false;
                  # vpn.enable = mkForce false;
                };

                llm = {
                  # ollama.enable = mkForce false;
                };

                docker = {
                  # enable = mkForce false;
                  # romm.enable = mkForce false;
                  # ourshoppinglist.enable = mkForce false;
                };

                # groceries.tandoor.enable = mkForce false;
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
