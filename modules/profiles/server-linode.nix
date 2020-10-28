{ nixpkgs, home-manager }:

{
  imports = [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./system/linode-lish.nix
    (import ./server.nix { inherit home-manager; })
  ];
}
