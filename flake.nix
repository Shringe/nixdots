{
  description = "First flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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
            ./hosts/luminum/nixos/configuration.nix 
          ];
        };
      };
      homeConfigurations = {
        shringe = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./hosts/luminum/home-manager/home.nix 
            inputs.nixvim.homeManagerModules.nixvim
          ];
        };
      };
    };
}
