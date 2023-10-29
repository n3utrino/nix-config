{ config, pkgs, ... }:
let
  settingsFile = ./alacritty.yml;
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      import = [ settingsFile ];   
    };

  };
}
