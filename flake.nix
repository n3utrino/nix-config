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

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      users.users.n3utrino.home = "/Users/n3utrino";

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;  # default shell on catalina
        enableFzfCompletion = true;
      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MBP-Gabe
    darwinConfigurations."MBP-Gabe" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./modules/darwin/config.nix
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.n3utrino = import ./home.nix;
        }
      ];


    };

    vmConfigurations."genericVm" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configuration
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.n3utrino = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MBP-Gabe".pkgs;
  };
}
