inputs:

{
  imports = [
    (import ./common.nix inputs)
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    kbdInteractiveAuthentication = false;
    passwordAuthentication = false;
    ports = [ 22 ];
  };

  services.sshguard.enable = true;

  services.wstunnel = {
    enable = true;
    listenAddress = "0.0.0.0:8080";
    restrictTo = "127.0.0.1:22";
  };
}
