{ lib, ... }:

let

  secrets = lib.readFile ./pap-secrets;

  name = lib.head (lib.remove "" (lib.splitString " " secrets));

in

{
  services.pppd = {
    enable = true;
    peers.default.config = ''
      linkname "ppp.float"

      updetach
      plugin rp-pppoe.so
      nic-enp3s0

      noauth
      defaultroute
      maxfail 5

      persist

      +ipv6

      name "${name}"
    '';
  };

  environment.etc."ppp/pap-secrets" = {
    text = secrets;
    mode = "0600";
  };
}
