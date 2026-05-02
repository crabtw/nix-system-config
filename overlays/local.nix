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
    assert prev.libtorrent-rakshasa.version == "0.16.8";
    prev.libtorrent-rakshasa.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.16.11";

        src = pkgs.fetchFromGitHub {
          owner = "rakshasa";
          repo = "libtorrent";
          tag = "v${finalAttrs.version}";
          hash = "sha256-T8Td2bQlO21ieXdJ+oZ4GytJiGxb9AcgBsygl8yMrpI=";
        };
      }
    );

  rtorrent =
    assert prev.rtorrent.version == "0.16.8";
    prev.rtorrent.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.16.11";

        src = pkgs.fetchFromGitHub {
          owner = "rakshasa";
          repo = "rtorrent";
          tag = "v${finalAttrs.version}";
          hash = "sha256-OEIJMBj1UfIOpR1w8c8ztKWJVD5hKxiJaxweF7mBRNM=";
        };

        doInstallCheck = false;
      }
    );

  xwayland-satellite =
    assert prev.xwayland-satellite.version == "0.8.1";
    prev.xwayland-satellite.overrideAttrs (
      finalAttrs: prevAttrs: {
        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/Supreeeme/xwayland-satellite/commit/10f985b84cdbcc3bbf35b3e7e43d1b2a84fa9ce2.patch";
            hash = "sha256-caWdCnbD4Yf7U9mdeMwYP1/xDjGg1jNvL1y2pq/C2GM=";
          })
        ];
      }
    );
}
