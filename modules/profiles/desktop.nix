{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./fonts/fontconfig
  ];

  environment.systemPackages = with pkgs; [
    libva-utils
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
    ];
  };

  services.openssh.enable = false;

  services.xserver = {
    enable = true;
    autorun = false;
    videoDrivers = [ "intel" ];
    libinput = {
      enable = true;
      leftHanded = true;
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
