{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.nhi-icc;

in

{
  options.services.nhi-icc = {
    enable = mkEnableOption "nhi-icc";
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;

    networking.hostFiles = [
      "${pkgs.nhi-icc}/share/NHIICC/hosts"
    ];

    systemd.services.nhi-icc = {
      description = "NHI IC card daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.nhi-icc}/bin/nhi-icc";
        PIDFile = "/tmp/exampled.lock";
      };
    };
  };
}
