{
  description = "First flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
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

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = false;
      };
    in {
      nixosConfigurations = {
        luminum = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [ 
            ./nixos/luminum/configuration.nix 
          ];
        };
      };
      homeConfigurations = {
        shringe = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./home-manager/shringe/home.nix 
            inputs.nixvim.homeManagerModules.nixvim
            ./home-manager/homeManagerModules
          ];
        };
      };
    };
}
