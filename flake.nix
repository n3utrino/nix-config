{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MBP-Gabe
    darwinConfigurations."Gabes-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./modules/darwin
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.n3utrino.imports = [./modules/home-manager];
        }
      ];


    };

    nixosConfigurations."nixtop" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configuration
        ./hosts/nixtop
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.n3utrino.imports = [./modules/home-manager];
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MBP-Gabe".pkgs;
  };
}
