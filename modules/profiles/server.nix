inputs:

{
  imports = [
    (import ./common.nix inputs)
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  services.sshguard.enable = true;
}
