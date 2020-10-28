{
  description = "My system configuration";

  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager }: {
    nixosModules = {
      desktop = import ./modules/profiles/desktop.nix {
        inherit sops-nix home-manager;
      };

      desktop-home = import ./modules/profiles/desktop-home.nix {
        inherit sops-nix home-manager;
      };

      server = import ./modules/profiles/server.nix {
        inherit home-manager;
      };

      server-linode = import ./modules/profiles/server-linode.nix {
        inherit nixpkgs home-manager;
      };

      home-desktop = import ./home/modules/profiles/desktop.nix;

      home-server = import ./home/modules/profiles/server.nix;
    };

    overlay = import ./overlays/local.nix;
  };
}
