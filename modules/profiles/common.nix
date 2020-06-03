{ options, pkgs, ... }:

{
  imports = [
    ../services/nhi-icc.nix
    ./services/logrotate.nix
  ];

  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages
    htop
    file
    git
  ];

  programs.vim.defaultEditor = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (import ../../overlays/local.nix)
  ];
}
