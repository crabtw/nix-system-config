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
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
    ];
  };

  services.openssh = {
    enable = true;
    listenAddresses = [
      { addr = "127.0.0.1"; port = 22; }
    ];
  };

  services.xserver = {
    enable = true;
    autorun = false;
    videoDrivers = [ "intel" ];
    libinput = {
      enable = true;
      mouse.leftHanded = true;
    };
    displayManager.startx.enable = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = [ pkgs.fcitx-engines.chewing ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #services.nhi-icc.enable = true;
  #nixpkgs.config.permittedInsecurePackages = [
  #  "openssl-1.0.2u"
  #];
}
