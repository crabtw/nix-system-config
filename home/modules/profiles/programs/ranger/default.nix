{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ranger
    atool
  ];

  xdg.configFile."ranger/commands.py".source = pkgs.runCommandLocal "ranger-config-command.py" {} ''
    install -m644 ${./commands.py} $out

    substituteInPlace $out \
      --replace aunpack "${pkgs.atool}/bin/aunpack" \
      --replace ffmpeg "${pkgs.ffmpeg}/bin/ffmpeg" \
      --replace mencoder "${pkgs.mplayer}/bin/mencoder"
  '';

  xdg.configFile."ranger/rifle.conf".source = pkgs.runCommandLocal "ranger-config-rifle.conf" {} ''
    install -m644 ${pkgs.ranger}/share/doc/ranger/config/rifle.conf $out

    sed -E -i \
      -e '/^mime[ ]+\^image,[ ]+has[ ]+imv,/ { s/imv( --)?/imv_rifle/g }' \
      -e 's/"\$PAGER"/\$PAGER/g' \
      $out
  '';

  xdg.configFile."ranger/rc.conf".text = ''
    set preview_images false
    set preview_files false
  '';
}
