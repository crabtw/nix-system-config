{ sops-nix, home-manager }:

{
  imports = [
    (import ./desktop.nix { inherit sops-nix home-manager; })
    ./services/pppd.nix
  ];
}
