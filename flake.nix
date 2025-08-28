{
  description = "Master flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    liberodark = {
      url = "github:liberodark/my-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwl = {
      url = "github:Shringe/dwl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nf = {
      url = "github:Shringe/nf";
    };

    # walker = {
    #   url = "github:abenz1267/walker";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        inputs.nur.overlays.default
        inputs.dwl.overlays.default
        inputs.nix-minecraft.overlay

        (self: super: {
          stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        })

        (self: super: {
          nf = inputs.nf.packages.${system}.default;
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
      ];

      # Binary cache provided here
      # https://docs.determinate.systems/guides/advanced-installation#nixos
      detSys = [
        inputs.determinate.nixosModules.default
        {
          nix.settings = {
            lazy-trees = true;
          };
        }
      ];

      pkgs = import nixpkgs-unstable {
        inherit system overlays;

        config.permittedInsecurePackages = [
          "jitsi-meet-1.0.8043"
        ];

        config.allowUnfree = true;
      };
    in
    {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };

      nixosConfigurations = with nixpkgs.lib; {
        deity = nixosSystem {
          specialArgs = { inherit system inputs pkgs; };
          modules = detSys ++ [
            ./nixos/deity/configuration.nix
            ./nixos/nixosModules
            ./shared
          ];
        };

        luminum = nixosSystem {
          specialArgs = { inherit system inputs pkgs; };
          modules = detSys ++ [
            ./nixos/luminum/configuration.nix
            ./nixos/nixosModules
            ./shared
          ];
        };
      };

      homeConfigurations = with inputs.home-manager.lib; {
        shringed = homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/shringed/home.nix
            ./home-manager/homeManagerModules
            inputs.nixvim.homeManagerModules.nixvim
            ./shared
          ];
        };

        shringe = homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
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
