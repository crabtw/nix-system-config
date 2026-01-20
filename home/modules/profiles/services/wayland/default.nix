{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xwayland-satellite
  ];

  programs.fuzzel = {
    enable = true;

    settings.main.terminal = "wezterm -e {cmd}";
  };

  programs.waybar = {
    enable = true;

    settings.mainBar = {
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "niri/window" ];
      modules-right = [
        "clock"
        "tray"
      ];

      "clock" = {
        format = "{:%Y-%m-%d, %H:%M}";
      };
    };
  };

  services.mako.enable = true;

  services.polkit-gnome.enable = true;

  services.swayidle.enable = true;

  programs.swaylock.enable = true;

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.configFile."niri/config.kdl".source = ./niri.kdl;
}
