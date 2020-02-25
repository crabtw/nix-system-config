{
  imports = [
    ../security/rngd.nix
  ];

  security.my-rngd.enable = true;
}
