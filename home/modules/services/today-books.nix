{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.today-books;

in

{
  options = {
    services.today-books = {
      enable = mkEnableOption "today-books";

      dataDir = mkOption {
        type = types.path;
        default = "${config.home.homeDirectory}/db/wawabook";
        description = ''
          Data directory for today-books.
        '';
      };

      dates = mkOption {
        type = types.str;
        default = "01:00:00";
        description = ''
          Specification of the time at
          which the today-books will run.
        '';
      };

      delay = mkOption {
        type = types.str;
        default = "0";
        description = ''
          Randomized delay seconds.
        '';
      };
    };
  };

  config = mkIf cfg.enable (
    let
      Unit = {
        Description = "Today books";
      };
    in
      {
        systemd.user.services.today-books = {
          inherit Unit;

          Service = {
            Type = "oneshot";
            ExecStart = toString (pkgs.writeScript "today-books" ''
              #!${pkgs.bash}/bin/bash

              set -euo pipefail

              DB_DIR="${cfg.dataDir}"
              DB_NAME="$(${pkgs.coreutils}/bin/date +%Y-%m-%d).txt"

              ${pkgs.coreutils}/bin/mkdir -p $DB_DIR
              ${pkgs.haskellPackages.wawabook}/bin/wawabook >$DB_DIR/$DB_NAME
            '');
          };
        };

        systemd.user.timers.today-books = {
          inherit Unit;

          Timer = {
            OnCalendar = "${cfg.dates}";
            RandomizedDelaySec = "${cfg.delay}";
            Persistent = "true";
          };

          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      }
  );
}
