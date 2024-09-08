{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./programs/ranger
    ./misc/home-bin
    ./services/xsession
  ];

  home.packages = with pkgs; [
    # X11
    xsel
    xorg.xdpyinfo
    vmware-horizon-client

    # utils
    cmus
    imagemagick
    ffmpeg
    abcde
    unrar
    p7zip
    lm_sensors
  ];

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
      local my_default = wezterm.color.get_default_colors()
      my_default.foreground = "light grey"
      my_default.brights[5] = "#6464ff"

      return {
          front_end = "WebGpu",

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

          color_schemes = {
              ["My Default"] = my_default,
          },
          color_scheme = "My Default",

          enable_tab_bar = false,
          scrollback_lines = 50000,

          use_ime = true,
      }
    '';
  };

  programs.rtorrent = {
    enable = true;
    extraConfig =
      let
        home = config.home.homeDirectory;
        downloadRate = 3000;
        uploadRate = 1000;
        downloadDir = "${home}/download";
        sessionDir = "${home}/tmp/rt-session";
        torrentDir = "${home}/download/torrents";
      in
        ''
          throttle.max_peers.normal.set = 300

          throttle.max_peers.seed.set = 3
          throttle.max_uploads.set = 3

          throttle.global_down.max_rate.set_kb = ${toString downloadRate}
          throttle.global_up.max_rate.set_kb = ${toString uploadRate}

          directory.default.set = ${downloadDir}

          session.path.set = ${sessionDir}

          schedule2 = watch_directory,5,5,load.start=${torrentDir}/*.torrent
          schedule2 = untied_directory,5,5,stop_untied=

          network.port_range.set = 38900-39990
          network.port_random.set = yes

          trackers.use_udp.set = yes

          protocol.encryption.set = allow_incoming,try_outgoing,enable_retry

          dht.mode.set = on
          dht.port.set = 38838

          protocol.pex.set = yes

          ui.torrent_list.layout.set = "full"
        '';
  };

  programs.mpv = {
    enable = true;
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
