inputs:

{
  imports = [
    (import ./common.nix inputs)
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    ports = [ 22 443 ];
  };

  services.sshguard.enable = true;
}
