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

  cmus = prev.cmus.overrideAttrs (_: prevAttrs: {
    patches = prevAttrs.patches ++ [(prev.fetchpatch {
      url = "https://github.com/cmus/cmus/commit/07ce2dc7082a1ed8704c21fd3f2877c8ba6b12f9.patch";
      hash = "sha256-5gsz3q8R9FPobHoLj8BQPsa9s4ULEA9w2VQR+gmpmgA=";
    })];
  });
}
