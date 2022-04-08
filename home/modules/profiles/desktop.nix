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
    citrix_workspace
    teams
    wezterm

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

  programs.rtorrent = {
    enable = true;
    settings =
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
      profile = "opengl-hq";
      vo = "gpu";
      ao = "pulse";
      hwdec = "vaapi";
      volume-max = "300";
    };
    bindings = {
      UP = "seek 30";
      DOWN = "seek -30";
    };
  };
}
