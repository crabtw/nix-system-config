{ config, ... }:

{
  services.pppd = {
    enable = true;
    peers.default.config = ''
      linkname "ppp.float"

      updetach
      plugin pppoe.so
      nic-enp42s0

      noauth
      defaultroute
      maxfail 5

      persist

      +ipv6

      file ${config.sops.secrets.pppd-secret-options.path}
    '';
  };

  sops.secrets.pppd-secret-options = {};

  sops.secrets.pap-secrets.path = "/etc/ppp/pap-secrets";
}
