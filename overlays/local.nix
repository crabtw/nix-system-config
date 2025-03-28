final: prev:

let

  pkgs = prev.pkgs;

  lib = prev.lib;

in {
  wqy_unibit = prev.callPackage ../pkgs/wqy-unibit.nix {};

  opendesktop-fonts = prev.callPackage ../pkgs/opendesktop-fonts.nix {};

  ipamonafont = prev.callPackage ../pkgs/ipamonafont.nix {};

  nhi-icc = prev.callPackage ../pkgs/nhi-icc.nix {};

  haskellPackages = prev.haskellPackages.override {
    overrides = final: prev: import ../pkgs/haskell-packages.nix {
      pkgs = pkgs;
      stdenv = pkgs.stdenv;
      callPackage = final.callPackage;
      hsPkgs = prev;
    };
  };

  vimPlugins = prev.vimPlugins // (
    let
      inherit (prev) vim;
      inherit (prev.vimUtils.override {inherit vim;}) buildVimPlugin;
    in
      {
        my-vim = prev.callPackage ../pkgs/my-vim-plugin.nix {
          inherit buildVimPlugin;
        };
      }
  );

  wstunnel-bin = prev.callPackage ../pkgs/wstunnel-bin.nix {};

  imv = let
      withBackends = [ "libjxl" "libtiff" "libjpeg" "libpng" "librsvg" "libheif" "libnsgif" ];

      libnsgif_patch = prev.fetchpatch {
        url = "https://lists.sr.ht/~exec64/imv-devel/%3C20241113012702.30521-2-reallyjohnreed@gmail.com%3E/raw";
        hash = "sha256-/OQeDfIkPtJIIZwL8jYVRy0B7LSBi9/NvAdPoDm851k=";
      };
    in
      (prev.imv.override { inherit withBackends; }).overrideAttrs (old:
        assert (old.version == "4.5.0"); {
        patches = [ libnsgif_patch ];
      });

  ranger = let
      ncurses_patch1 = prev.fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/ranger/-/raw/main/ranger-1.9.4-fix-ncurses-endwin-error-1.patch?ref_type=heads&inline=false";
        hash = "sha256-/vII8FyoQNfu6U9YXOWwBk+1WN7Ffe6OwvLuYUL5854=";
      };

      ncurses_patch2 = prev.fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/ranger/-/raw/main/ranger-1.9.4-fix-ncurses-endwin-error-2.patch?ref_type=heads&inline=false";
        hash = "sha256-jDr2Hqmhy4nAZijGHg77aoLHOB4p7oANxwx1E2NMZOk=";
      };

      ncurses_patch3 = prev.fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/ranger/-/raw/main/ranger-1.9.4-fix-ncurses-endwin-error-3.patch?ref_type=heads&inline=false";
        hash = "sha256-QekaSj5tuxgL1emjaPAg+xVNfCyyZp/EviKL6ZxkydU=";
      };
    in
      prev.ranger.overrideAttrs (old:
        assert (old.version == "1.9.4"); {
        patches = [ ncurses_patch2 ncurses_patch1 ncurses_patch3 ];
      });
}
