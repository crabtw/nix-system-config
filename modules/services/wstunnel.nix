{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.wstunnel;

in

{
  options.services.wstunnel = {
    enable = mkEnableOption "wstunnel";

    bindAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
    };

    restrictTo = mkOption {
      type = types.nullOr types.str;
      default = "127.0.0.1:22";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.wstunnel = {
      description = "websocket tunnel";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig =
        let
          needsPrivileges = cfg.port < 1024;
          capabilities = [ "" ] ++ optionals needsPrivileges [ "CAP_NET_BIND_SERVICE" ];
        in {
          ExecStart = "${pkgs.wstunnel}/bin/wstunnel"
            + " --server wss://${cfg.bindAddress}:${toString cfg.port}"
            + optionalString (cfg.restrictTo != null) " -r ${cfg.restrictTo}";
          Restart = "always";
          RestartSec = "10s";
          # User and group
          DynamicUser = true;
          # Proc filesystem
          ProcSubset = "pid";
          ProtectProc = "invisible";
          # Capabilities
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateIPC = true;
          PrivateUsers = !needsPrivileges;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
    };
  };
}
