{ options, pkgs, ... }:

{
  imports = [
    ../services/nhi-icc.nix
    ./services/logrotate.nix
  ];

  environment.systemPackages = with pkgs; [
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
