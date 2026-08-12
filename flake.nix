# ~/dotfiles/flake.nix
{
  description = "My NixOS Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations.taurus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # Makes inputs available to your modules
      modules = [
        inputs.xremap-flake.nixosModules.default
        # Import the main configuration for the machine named "taurus"
        ./nixos/hosts/taurus/configuration.nix
      ];
    };
  };
}
