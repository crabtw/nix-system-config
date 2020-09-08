self: super:

{
  wqy_unibit = super.callPackage ../pkgs/wqy-unibit.nix {};

  opendesktop-fonts = super.callPackage ../pkgs/opendesktop-fonts.nix {};

  ipamonafont = super.callPackage ../pkgs/ipamonafont.nix {};

  noto-fonts-serif-cjk = super.callPackage ../pkgs/noto-fonts-serif-cjk.nix {};

  nhi-icc = super.callPackage ../pkgs/nhi-icc.nix {};
}
