{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;


    plugins = with pkgs.vimPlugins; [
#      vim-nix
      telescope-nvim
      nvim-web-devicons
      gitsigns-nvim
      vim-numbertoggle
#      ale
#      nvim-treesitter
#      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs;
    [
      ripgrep git fd
    ];


    extraConfig = ''
      let mapleader = "<"
      " Configure Telescope
      " Find files using Telescope command-line sugar.
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      
      set smartindent
      set number
      lua require 'gitsigns'.setup()
    '';
  };
}
