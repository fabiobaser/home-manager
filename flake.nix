{
  description = "fabiobaser home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {                                          # <-- add this
      url = "github:ogulcancelik/herdr/v0.7.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, herdr, ... }:
    let

      flakeRoot = self;

      mkLinux = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./modules/home/base.nix
          ./modules/home/linux.nix
        ];
	extraSpecialArgs = { inherit flakeRoot herdr; };
      };

      mkDarwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/darwin/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
	      extraSpecialArgs = { inherit flakeRoot herdr; };
              useGlobalPkgs   = true;
              useUserPackages = true;
              users.fabiobaser.imports = [
                ./modules/home/base.nix
                ./modules/home/darwin.nix
              ];
            };
          }
        ];
      };
    in
    {
      # home-manager switch --flake .#fabiobaser-linux
      homeConfigurations."linux" = mkLinux;

      # darwin-rebuild switch --flake .#fabiobaser-mac
      darwinConfigurations."mac" = mkDarwin;
    };
}
