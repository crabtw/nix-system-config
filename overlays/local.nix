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

  qt6Packages = prev.qt6Packages // {
    fcitx5-qt = prev.qt6Packages.fcitx5-qt.overrideAttrs (
      finalAttrs: prevAttrs:
      assert !(prevAttrs ? patches);
      {
        patches = [
          (prev.fetchpatch2 {
            url = "https://github.com/fcitx/fcitx5-qt/commit/46a07a85d191fd77a1efc39c8ed43d0cd87788d2.patch?full_index=1";
            hash = "sha256-qv8Rj6YoFdMQLOB2R9LGgwCHKdhEji0Sg67W37jSIac=";
          })
          (prev.fetchpatch2 {
            url = "https://github.com/fcitx/fcitx5-qt/commit/6ac4fdd8e90ff9c25a5219e15e83740fa38c9c71.patch?full_index=1";
            hash = "sha256-x0OdlIVmwVuq2TfBlgmfwaQszXLxwRFVf+gEU224uVA=";
          })
          (prev.fetchpatch2 {
            url = "https://github.com/fcitx/fcitx5-qt/commit/1d07f7e8d6a7ae8651eda658f87ab0c9df08bef4.patch?full_index=1";
            hash = "sha256-22tKD7sbsTJcNqur9/Uf+XAvMvA7tzNQ9hUCMm+E+E0=";
          })
        ];
      }
    );
  };
}
