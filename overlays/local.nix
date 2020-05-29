self: super:

let

  inherit (super) lib;

  version = "0.8.4";

  newVer = old: {
    name = lib.replaceStrings [ version ] [ "2020-01-31" ] old.name;

    src = super.fetchFromGitHub {
      owner = "zfsonlinux";
      repo = "zfs";
      rev = "591505dc2737bcd77c587e369e1d91b0fd97325c";
      sha256 = "16hfmld9pa0hir6bva9hiiwhc7hw2knx81y65v2pv78df483nn7w";
    };

    patches = if old ? extraPatches then old.extraPatches else [];

    postPatch = lib.replaceStrings
      [ "./module/zfs/zfs_ctldir.c"
        "./lib/libzfs/libzfs_mount.c"
      ]
      [ "./module/os/linux/zfs/zfs_ctldir.c"
        "./lib/libzfs/os/linux/libzfs_mount_os.c"
      ]
      old.postPatch;
  };

  makeNewVer = old:
    if lib.hasInfix version old.name
      then newVer old
      else old;
in

{
  linuxPackages = super.linuxPackages.extend (kself: ksuper: {
      zfsUnstable = ksuper.zfsUnstable.overrideAttrs makeNewVer;
    }
  );

  zfsUnstable = super.zfsUnstable.overrideAttrs makeNewVer;

  wqy_unibit = super.callPackage ../pkgs/wqy-unibit.nix {};

  opendesktop-fonts = super.callPackage ../pkgs/opendesktop-fonts.nix {};

  ipamonafont = super.callPackage ../pkgs/ipamonafont.nix {};

  noto-fonts-serif-cjk = super.callPackage ../pkgs/noto-fonts-serif-cjk.nix {};

  nhi-icc = super.callPackage ../pkgs/nhi-icc.nix {};
}
