final: prev:

let

  pkgs = prev.pkgs;

  lib = prev.lib;

in
{
  wqy_unibit = prev.callPackage ../pkgs/wqy-unibit.nix { };

  opendesktop-fonts = prev.callPackage ../pkgs/opendesktop-fonts.nix { };

  ipamonafont = prev.callPackage ../pkgs/ipamonafont.nix { };

  nhi-icc = prev.callPackage ../pkgs/nhi-icc.nix { };

  haskellPackages = prev.haskellPackages.override {
    overrides =
      final: prev:
      import ../pkgs/haskell-packages.nix {
        pkgs = pkgs;
        stdenv = pkgs.stdenv;
        callPackage = final.callPackage;
        hsPkgs = prev;
      };
  };

  vimPlugins =
    prev.vimPlugins
    // (
      let
        inherit (prev) vim;
        inherit (prev.vimUtils.override { inherit vim; }) buildVimPlugin;
      in
      {
        my-vim = prev.callPackage ../pkgs/my-vim-plugin.nix {
          inherit buildVimPlugin;
        };
      }
    );

  wstunnel-bin = prev.callPackage ../pkgs/wstunnel-bin.nix { };

  trayer = prev.trayer.overrideAttrs (
    finalAttrs: prevAttrs: {
      patches = [
        (prev.fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/trayer-srg-trayer-1.1.8-bg_init_prototype.patch?h=trayer";
          hash = "sha256-wLrWA/vs9A+gpoRQ/tvOv+0ip/6aS2HlL9EPx6Xnf+c=";
        })
      ];
    }
  );
}
