{ lib, ... }:

let

  secrets = import ./pap-secrets.nix;

  name = lib.head (lib.splitString " " secrets);

in

{
  imports = [ ../../services/pppd.nix ];

  services.my-pppd = {
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
