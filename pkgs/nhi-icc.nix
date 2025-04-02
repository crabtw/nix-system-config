{
  stdenv,
  buildFHSUserEnv,
  fetchurl,
  unzip,
  openssl_1_0_2,
}:

let

  nhiiccFiles = stdenv.mkDerivation {
    pname = "nhiiccFiles";

    version = "2020";

    src = fetchurl {
      url = "https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mLNHIICC_Setup.Ubuntu.zip";
      sha256 = "1kvlsb898330qn5b3m45xqwxgy67v8mdzxnrbsdnkwfv2wig65sy";
    };

    nativeBuildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
      tar xf mLNHIICC_Setup.tar.gz
      cd mLNHIICC_Setup
    '';

    installPhase = ''
      mkdir -p $out/share/NHIICC

      cp ./x64/mLNHIICC $out/share/NHIICC/
      chmod +x $out/share/NHIICC/mLNHIICC

      cp -a ./html $out/share/NHIICC/
      cp -a ./cert $out/share/NHIICC/
    '';
  };

  openssl_1_0_2_verSymPatch = fetchurl {
    url = "https://github.com/archlinux/svntogit-packages/raw/packages/openssl-1.0/trunk/openssl-1.0-versioned-symbols.patch";
    sha256 = "19nakabjbj689aw1wml3clwp3hmriy7nn8frxdww6difr7j88fim";
  };

  openssl_1_0_2_verSym = openssl_1_0_2.overrideAttrs (old: {
    patches = old.patches ++ [ openssl_1_0_2_verSymPatch ];
  });

in
buildFHSUserEnv {
  name = "nhi-icc";

  targetPkgs =
    pkgs: with pkgs; [
      nhiiccFiles
      pcsclite
      openssl_1_0_2_verSym
    ];

  extraBuildCommands = ''
    mkdir -p $out/usr/local/share
    ln -s $out/usr/share/NHIICC $out/usr/local/share/
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/NHIICC
    echo '127.0.0.1 iccert.nhi.gov.tw' >$out/share/NHIICC/hosts
  '';

  runScript = "${nhiiccFiles}/share/NHIICC/mLNHIICC";
}
