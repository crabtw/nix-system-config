{ ... }:

{
  imports = [ ./common.nix ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
  };

  services.sshguard.enable = true;
}
