nixpkgs:

{
  imports = [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./system/linode-lish.nix
    ./server.nix
  ];
}
