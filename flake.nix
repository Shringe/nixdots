{
  description = "Master flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
	
    disko = {
      url = "github:nix-community/disko";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-colors = {
    #   url = "github:misterio77/nix-colors";
    # };

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

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs:
    let
      system = "x86_64-linux";
      unstablePkgs = import nixpkgs {
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

      stablePkgs = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };

      # Default pkgs
      pkgs = unstablePkgs;
    in {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };

      nixosConfigurations = with nixpkgs.lib; {
        deity = nixosSystem {
          specialArgs = { inherit system inputs pkgs stablePkgs unstablePkgs; };
          modules = [ 
            ./nixos/deity/configuration.nix 
            ./nixos/nixosModules
          ];
        };

        luminum = nixosSystem {
          specialArgs = { inherit system inputs pkgs stablePkgs unstablePkgs; };
          modules = [ 
            ./nixos/luminum/configuration.nix 
            ./nixos/nixosModules
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
          ];
        };

        shringe = homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs stablePkgs unstablePkgs; };
          modules = [ 
            ./home-manager/shringe/home.nix 
            ./home-manager/homeManagerModules
            inputs.nixvim.homeManagerModules.nixvim
          ];
        };
      };
    };
}
