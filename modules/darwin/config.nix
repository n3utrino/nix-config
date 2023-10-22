{pkgs, ...}:
{
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # enable fingerprint sudo 
      security.pam.enableSudoTouchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
      system.defaults.finder = {

        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      system.defaults.dock = {
        orientation = "left";
        autohide = true;
      };


      environment.systemPackages = [ 
        pkgs.vim
        pkgs.fzf
        pkgs.pam-reattach
        pkgs.coreutils-full
      ];

      fonts.fontDir.enable = true;
      fonts.fonts = [
        (pkgs.nerdfonts.override {fonts = ["FiraCode" "FiraMono" "IBMPlexMono"];})
      ];

    }

