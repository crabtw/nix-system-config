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
}
