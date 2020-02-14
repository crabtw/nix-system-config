{ ... }:

{
  imports = [ ./common.nix ];

  services.openssh.enable = false;

  services.xserver = {
    enable = true;
    autorun = false;
    videoDrivers = [ "intel" ];
    displayManager.startx.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  fonts.fontconfig.useEmbeddedBitmaps = true;
}
