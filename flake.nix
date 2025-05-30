{
  description = "Master flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    nix-gaming.url = "github:fufexan/nix-gaming";

    disko = {
      url = "github:nix-community/disko";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
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
      url = "github:nix-community/home-manager/release-25.05";
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
      pkgs = stablePkgs;
    in {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };

      nixosConfigurations = with nixpkgs.lib; {
        deity = nixosSystem {
          specialArgs = { inherit system inputs pkgs stablePkgs unstablePkgs oldPkgs; };
          modules = [ 
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
