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

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      environment.systemPackages = [ 
        pkgs.vim
        pkgs.fzf
        pkgs.pam-reattach
        pkgs.coreutils-full
      ];

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;  # default shell on catalina
        enableFzfCompletion = true;
      };
      
      fonts.fontDir.enable = true;
      fonts.fonts = [
        (pkgs.nerdfonts.override {fonts = ["FiraCode" "FiraMono" "IBMPlexMono"];})
      ];

    }

