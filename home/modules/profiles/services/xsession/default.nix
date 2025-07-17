{ pkgs, ... }:

{
  home.packages = with pkgs; [
    haskellPackages.xmobar
  ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  xdg.configFile."xmobar/xmobarrc".text = ''
    Config {
        font = "DejaVu Sans Mono Bold 11",
        bgColor = "black",
        fgColor = "light grey",
        position = TopW L 90,
        lowerOnStart = True,
        commands = [
            Run Date "%Y-%m-%d, %H:%M" "date" 300,
            Run StdinReader
        ],
        sepChar = "%",
        alignSep = "}{",
        template = "%StdinReader% }{ <fc=#FFA500>%date%</fc>"
    }
  '';

  systemd.user.targets = {
    hm-graphical-session = {
      Unit = {
        Description = "Home Manager X session";
        Requires = [
          "graphical-session-pre.target"
        ];
        BindsTo = [
          "graphical-session.target"
          "tray.target"
        ];
      };
    };

    tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
  };

  home.file.".xinitrc".text = ''
    export LANG="zh_TW.UTF-8"
    export LC_ALL="zh_TW.UTF-8"

    systemctl --user import-environment \
      DBUS_SESSION_BUS_ADDRESS \
      DISPLAY \
      SSH_AUTH_SOCK \
      XAUTHORITY \
      XDG_DATA_DIRS \
      XDG_RUNTIME_DIR \
      XDG_SESSION_ID

    systemctl --user start hm-graphical-session.target

    fcitx5 -d -r

    # common
    ${pkgs.xorg.xrdb}/bin/xrdb -merge $HOME/.Xresources

    # xmonad
    ${pkgs.trayer}/bin/trayer \
      --edge top --align right --SetDockType true --SetPartialStrut true \
      --expand true --width 10 --transparent true --tint 0x000000 --height 18 &
    ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr -fg gray -bg black -solid black &
    ${pkgs.xmonad-with-packages}/bin/xmonad

    systemctl --user stop graphical-session.target
    systemctl --user stop graphical-session-pre.target

    while [ -n "$(systemctl --user --no-legend --state=deactivating list-units)" ]; do
      sleep 0.5
    done

    systemctl --user unset-environment \
      DBUS_SESSION_BUS_ADDRESS \
      DISPLAY \
      SSH_AUTH_SOCK \
      XAUTHORITY \
      XDG_DATA_DIRS \
      XDG_RUNTIME_DIR \
      XDG_SESSION_ID
  '';
}
