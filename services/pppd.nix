{
  imports = [ ../modules/pppd.nix ];

  services.my-pppd = {
    enable = true;
    peers.default.config = ''
      linkname "ppp.float"

      updetach
      plugin rp-pppoe.so
      nic-eth0

      noauth
      defaultroute
      maxfail 5

      persist

      +ipv6
    '';
  };

  environment.etc."ppp/pap-secrets" = {
    text = import ./pap-secrets.nix;
    mode = "0600";
  };
}
