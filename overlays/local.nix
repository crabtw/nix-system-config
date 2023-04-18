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
      inherit (prev.vimUtils.override {inherit vim;}) buildVimPluginFrom2Nix;
    in
      {
        my-vim = prev.callPackage ../pkgs/my-vim-plugin.nix {
          inherit buildVimPluginFrom2Nix;
        };
      }
  );

  vmware-horizon-client = prev.vmware-horizon-client.override {
    buildFHSEnv = prev.buildFHSEnvChroot;
  };
}
