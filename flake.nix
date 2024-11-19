{
  description = "First flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nix-colors = {
      url = "github:misterio77/nix-colors";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          inputs.nur.overlay
        ];
        config.allowUnfreePredicate = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
      };
    in {
      devShells.x86_64-linux.default = import ./devshell.nix {
        inherit pkgs;
      };
      nixosConfigurations = {
        luminum = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [ 
            ./nixos/luminum/configuration.nix 
            ./nixos/nixosModules
          ];
        };
      };
      homeConfigurations = {
        shringed = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgs-stable; };
          modules = [ 
            ./home-manager/shringed/home.nix 
            ./home-manager/homeManagerModules
            inputs.nixvim.homeManagerModules.nixvim
          ];
        };
        shringe = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgs-stable; };
          modules = [ 
            ./home-manager/shringe/home.nix 
            ./home-manager/homeManagerModules
            inputs.nixvim.homeManagerModules.nixvim
          ];
        };
      };
    };
}
