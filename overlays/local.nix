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

  wawabook-bin = prev.callPackage ../pkgs/wawabook-bin.nix { };

  wstunnel-bin = prev.callPackage ../pkgs/wstunnel-bin.nix { };

  libtorrent-rakshasa =
    assert prev.libtorrent-rakshasa.version == "0.16.22";
    prev.libtorrent-rakshasa.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.16.25";

        src = pkgs.fetchFromGitHub {
          owner = "rakshasa";
          repo = "libtorrent";
          tag = "v${finalAttrs.version}";
          hash = "sha256-WxhAu2BXxlqPidoItMXnKyw5uTUk9ogmUBWohIdvQSo=";
        };
      }
    );

  rtorrent =
    assert prev.rtorrent.version == "0.16.22";
    prev.rtorrent.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.16.25";

        src = pkgs.fetchFromGitHub {
          owner = "rakshasa";
          repo = "rtorrent";
          tag = "v${finalAttrs.version}";
          hash = "sha256-uZ1Y3fKOv0KaUBRjuanEkkB88E+U8/cOBEcFrLjiHC0=";
        };

        doInstallCheck = false;
      }
    );
}
