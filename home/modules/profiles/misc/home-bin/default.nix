{ pkgs, ... }:

{
  home.sessionVariables.PATH = "$HOME/bin:$PATH";

  home.file."bin/utils.rb".source = ./utils.rb;

  home.file."bin/dmenu_run".source = pkgs.runCommandLocal "home-bin-dmenu_run.sh" {} ''
    install -m755 ${./dmenu_run.sh} $out

    substituteInPlace $out \
      --replace /bin/sh "${pkgs.runtimeShell}" \
      --replace setsid "${pkgs.util-linux}/bin/setsid" \
      --replace dmenu "${pkgs.dmenu}/bin/dmenu"
  '';

  home.file."bin/feh_rifle".source = pkgs.runCommandLocal "home-bin-feh_rifle.rb" {} ''
    install -m755 ${./feh_rifle.rb} $out

    substituteInPlace $out \
      --replace "/usr/bin/env ruby" "${pkgs.ruby}/bin/ruby" \
      --replace feh "${pkgs.feh}/bin/feh"
  '';

  home.file."bin/imv_rifle".source = pkgs.runCommandLocal "home-bin-imv_rifle.rb" {} ''
    install -m755 ${./imv_rifle.rb} $out

    substituteInPlace $out \
      --replace "/usr/bin/env ruby" "${pkgs.ruby}/bin/ruby" \
      --replace imv "${pkgs.imv}/bin/imv"
  '';

  home.file."bin/seq-rename".source = pkgs.runCommandLocal "home-bin-seq-rename.rb" {} ''
    install -m755 ${./seq-rename.rb} $out

    substituteInPlace $out \
      --replace "/usr/bin/env ruby" "${pkgs.ruby}/bin/ruby"
  '';

  home.file."bin/chperm.backup".source = pkgs.runCommandLocal "home-bin-chperm.backup.rb" {} ''
    install -m755 ${./chperm.backup.rb} $out

    substituteInPlace $out \
      --replace "/usr/bin/env ruby" "${pkgs.ruby}/bin/ruby"
  '';
}
