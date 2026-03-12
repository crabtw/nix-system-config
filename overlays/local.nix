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

  libtorrent-rakshasa =
    assert prev.libtorrent-rakshasa.version == "0.16.6";
    prev.libtorrent-rakshasa.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.16.7";

        src = pkgs.fetchFromGitHub {
          owner = "rakshasa";
          repo = "libtorrent";
          tag = "v${finalAttrs.version}";
          hash = "sha256-cCUgmDiXapJw00rQlU3fcnEEIzWXy9d9UieKuxdhxBE=";
        };
      }
    );

  rtorrent =
    assert prev.rtorrent.version == "0.16.6";
    prev.rtorrent.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.16.7";

        src = pkgs.fetchFromGitHub {
          owner = "rakshasa";
          repo = "rtorrent";
          tag = "v${finalAttrs.version}";
          hash = "sha256-bgCVzsyTm3i3dgLZq02OyaOM0cJ0GjLDNp6dBES0RJI=";
        };
      }
    );
}
