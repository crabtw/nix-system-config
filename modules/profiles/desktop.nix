{ sops-nix, ... }@inputs: { pkgs, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
    (import ./common.nix inputs)
    ./fonts/fontconfig
  ];

  sops.defaultSopsFile = ./secrets/desktop.yaml;

  environment.systemPackages = with pkgs; [
    pavucontrol
    libva-utils
    gptfdisk
    smartmontools
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  services.openssh = {
    enable = true;
    listenAddresses = [
      { addr = "127.0.0.1"; port = 22; }
    ];
  };

  services.libinput = {
    enable = true;
    mouse.leftHanded = false;
  };

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-chewing ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #services.nhi-icc.enable = true;
  #nixpkgs.config.permittedInsecurePackages = [
  #  "openssl-1.0.2u"
  #];
}
