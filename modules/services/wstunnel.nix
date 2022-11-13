{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.wstunnel;

in

{
  options.services.wstunnel = {
    enable = mkEnableOption "wstunnel";

    user = mkOption {
      type = types.str;
      default = "nobody";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0:8080";
    };

    restrictTo = mkOption {
      type = types.str;
      default = "127.0.0.1:22";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.wstunnel = {
      description = "websocket tunnel";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wstunnel}/bin/wstunnel --server wss://${cfg.listenAddress}"
          + lib.optionalString (cfg.restrictTo != null) " -r ${cfg.restrictTo}";
        User = cfg.user;
        Restart = "always";
        RestartSec = "10s";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };
  };
}
