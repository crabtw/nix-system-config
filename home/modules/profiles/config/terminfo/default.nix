{ pkgs, ... }:

{
  home.sessionVariables = {
    TERMINFO = pkgs.runCommandLocal "terminfo" { } ''
      ${pkgs.ncurses}/bin/tic -o $out ${./terminfo.src}
    '';
  };
}
