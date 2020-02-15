{ pkgs, ... }:

{
  imports = [ ./common.nix ];

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

  fonts.fontconfig.useEmbeddedBitmaps = true;
}
