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
    openFirewall = true;
    bindAddress = "0.0.0.0";
    port = 8080;
    restrictTo = "127.0.0.1:22";
  };
}
