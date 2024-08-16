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
        url = "https://lists.sr.ht/~exec64/imv-devel/%3C20240301211856.8170-1-dev@kz6wk9.com%3E/raw";
        hash = "sha256-4sqEU6SqlYSlvCUpGYs86omIe0SW6J8xqCygiwlwBps=";
      };
    in
      (prev.imv.override { inherit withBackends; }).overrideAttrs (old:
        assert (old.version == "4.5.0"); {
        patches = [ libnsgif_patch ];
      });
}
