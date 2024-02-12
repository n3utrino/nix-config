{ config, pkgs, lib, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
imports = [ ../../packages/nvim ../../packages/alacritty ];

  home.packages = [
    pkgs.prettyping
    pkgs.nodejs
    pkgs.nodePackages."@angular/cli"
    pkgs.gradle
    pkgs.spring-boot-cli
    pkgs.graphviz
    pkgs.imagemagick
    pkgs.nmap
    pkgs.difftastic
    pkgs.magic-wormhole-rs
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  #home.shellAliases = 
  #  {
#	ping = "prettyping";
 #       ls = "ls --color";
  #      ll = "ls -l --color";
   #     wormhole = "wormhole-rs";
 # };

  programs = {
    git =  {
      enable = true;
      extraConfig = {
        user.email = "n3utrino@eleet.ch";
        user.name = "n3utrino";
      };
    };
    java.enable=true;
    direnv.enable=true;

    zsh = { 
      enable=true;
    };
  };

      programs.tmux = {
        enable = true;
        terminal = "tmux-256color";
        plugins = with pkgs; 
        [tmuxPlugins.nord];
      };

 # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/n3utrino/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
     EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };
}
