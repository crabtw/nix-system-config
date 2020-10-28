{
  description = "My system configuration";

  inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix }: {
    nixosModules = {
      desktop = import ./modules/profiles/desktop.nix sops-nix;

      server = import ./modules/profiles/server.nix;

      linode = import ./modules/profiles/linode.nix nixpkgs;

      home-desktop = import ./home/modules/profiles/desktop.nix;

      home-server = import ./home/modules/profiles/server.nix;
    };

    overlay = import ./overlays/local.nix;
  };
}
