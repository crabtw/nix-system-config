{
  description = "My system configuration";

  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager }@inputs: {
    nixosModules = {
      desktop = import ./modules/profiles/desktop.nix inputs;

      desktop-home = {
        imports = [
          (import ./modules/profiles/desktop.nix inputs)
          ./modules/profiles/services/pppd.nix
        ];
      };

      server = import ./modules/profiles/server.nix inputs;

      server-linode = {
        imports = [
          (import ./modules/profiles/server.nix inputs)
          "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
          ./modules/profiles/system/linode-lish.nix
        ];
      };

      home-desktop = import ./home/modules/profiles/desktop.nix;

      home-server = import ./home/modules/profiles/server.nix;
    };

    overlay = import ./overlays/local.nix;
  };
}
