{ home-manager }: { options, pkgs, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
    ../services/nhi-icc.nix
    ./services/logrotate.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

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

  nix = {
    package = pkgs.nixUnstable;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      (import ../../overlays/local.nix)
    ];
  };
}
