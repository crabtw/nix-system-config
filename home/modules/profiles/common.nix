{ config, pkgs, ... }:

{
  imports = [
    ../services/today-books.nix
    ./config/terminfo
    ./programs/direnv
  ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # utils
    file
    zip
    unzip
    pstree
    lsof
    fd
    ripgrep
    inetutils
    dnsutils
    gnupg
    jq

    # dev
    tig
    ruby
    shellcheck
    niv
    nushell
    nixfmt-rfc-style
  ];

  accounts.email.accounts.gmail = {
    primary = true;
    realName = "Jyun-Yan You";
    address = "jyyou.tw@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      less = "less -i";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
    };
  };

  programs.git = with config.accounts.email.accounts; {
    enable = true;
    userName = gmail.realName;
    userEmail = gmail.address;
    signing.format = "ssh";
    aliases = {
      pullall = "!git pull && git submodule sync && git submodule update --init --recursive --progress";
    };
    extraConfig = {
      pull.rebase = false;
      rerere.enabled = true;
    };
    delta = {
      enable = true;
      options = {
        dark = true;
        line-numbers = true;
      };
    };
    lfs.enable = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    historyLimit = 50000;
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      my-vim
      rust-vim
      vim-nix
      zig-vim
    ];
    extraConfig = ''
      set nocompatible
      set ruler

      set expandtab
      set softtabstop=4
      set shiftwidth=4

      set fileformat=unix
      set fileformats=unix,dos,mac

      set encoding=utf-8
      set fileencoding=utf-8
      set fileencodings=ucs-bom,utf-8,big5,latin1

      set hlsearch
      colorscheme torte

      syntax on
    '';
  };

  home.sessionVariables.EDITOR = "vim";
}
