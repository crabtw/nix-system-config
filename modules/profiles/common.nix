{ nixpkgs, home-manager, ... }: { options, pkgs, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
    ../services/nhi-icc.nix
    ../services/wstunnel-rs.nix
    ./services/logrotate.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  documentation.dev.enable = true;

  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
  ];

  environment.systemPackages = with pkgs; [
    man-pages
    htop
    file
    git
    git-lfs
  ];

  programs.vim.defaultEditor = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };

  nix = {
    package = pkgs.nixVersions.latest;

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

    registry = {
      nixpkgs.flake = nixpkgs;
      home-manager.flake = home-manager;
    };
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
