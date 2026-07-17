{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./programs/ranger
    ./misc/home-bin
    #./services/xsession
    ./services/wayland
  ];

  home.packages = with pkgs; [
    # X11
    xsel
    xdpyinfo
    omnissa-horizon-client

    # utils
    cmus
    imagemagick
    ffmpeg
    cyanrip
    unrar
    _7zz
    lm_sensors
  ];

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-chewing ];
      waylandFrontend = true;
    };
  };

  programs.firefox.enable = true;

  programs.chromium.enable = true;

  programs.zathura.enable = true;

  programs.urxvt = {
    enable = true;
    package = pkgs.rxvt-unicode;
    scroll.bar.enable = false;
    iso14755 = false;
    fonts = [
      "xft:Inconsolata Nerd Font Mono:pixelsize=17"
      "xft:AR PL New Sung Mono:pixelsize=16"
      "xft:IPAexGothic:pixelsize=16"
      "xft:DejaVu Sans Mono:pixelsize=16"
      "xft:FreeMono:pixelsize=16"
    ];
    extraConfig = {
      "background" = "black";
      "foreground" = "lightgray";
      "color12" = "#6464ff";
    };
  };

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    extraConfig = ''
      return {
          front_end = "OpenGL",

          font = wezterm.font_with_fallback({
              "Inconsolata Nerd Font Mono",
              "Noto Sans CJK TC",
              "Noto Sans CJK JP",
              "Noto Sans CJK SC",
              "AR PL New Sung Mono",
              "IPAexGothic",
              "DejaVu Sans Mono",
              "FreeMono",
          }),
          font_size = 13.0,
          harfbuzz_features = {"calt=0", "clig=0", "liga=0"},

          color_scheme = "ayu",
          colors = {
              foreground = "light grey",
              background = "black",
          },

          enable_tab_bar = false,
          scrollback_lines = 50000,

          use_ime = true,
      }
    '';
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "Ayu";
      background = "black";
      foreground = "light grey";

      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;

      window-decoration = false;
      gtk-titlebar = false;
      scrollback-limit = 50000;

      shell-integration-features = [ "no-cursor" ];

      font-size = 13;
      font-family = [
        "Inconsolata Nerd Font Mono"
        "Noto Sans CJK TC"
        "Noto Sans CJK JP"
        "Noto Sans CJK SC"
        "AR PL New Sung Mono"
        "IPAexGothic"
        "DejaVu Sans Mono"
        "FreeMono"
      ];
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];
    };
  };

  programs.rtorrent = {
    enable = true;
    extraConfig =
      let
        home = config.home.homeDirectory;
        downloadRate = 10000;
        uploadRate = 10000;
        downloadDir = "${home}/download";
        sessionDir = "${home}/tmp/rt-session";
        torrentDir = "${home}/download/torrents";
      in
      ''
        throttle.max_peers.normal.set = 300

        throttle.max_peers.seed.set = 10
        throttle.max_uploads.set = 10

        throttle.global_down.max_rate.set_kb = ${toString downloadRate}
        throttle.global_up.max_rate.set_kb = ${toString uploadRate}

        directory.default.set = ${downloadDir}

        session.path.set = ${sessionDir}

        schedule = watch_directory,5,5,load.start=${torrentDir}/*.torrent
        schedule = untied_directory,5,5,stop_untied=

        network.listen.port.set = 39429

        protocol.encryption.set = prefer

        dht.mode.set = auto

        protocol.pex.set = yes

        ui.torrent_list.layout.set = "full"
      '';
  };

  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      youtubeSupport = false;
    };
    config = {
      profile = "high-quality";
      vo = "gpu";
      ao = "pipewire";
      hwdec = "vaapi";
      volume-max = "300";
    };
    bindings = {
      UP = "seek 30";
      DOWN = "seek -30";
    };
  };
}
