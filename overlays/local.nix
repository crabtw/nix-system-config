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

  btrfs-progs = assert prev.btrfs-progs.version == "6.6"; prev.btrfs-progs.overrideAttrs (_: _: {
    version = "6.5.3";
    src = prev.fetchurl {
      url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v6.5.3.tar.xz";
      hash = "sha256-/OfLP5IOYV5j+vJlpM2fK/OdStyqZiEcmHaX2oWi7t0=";
    };
  });
}
