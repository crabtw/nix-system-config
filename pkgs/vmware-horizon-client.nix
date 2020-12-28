{ stdenv, buildFHSUserEnv, fetchurl, makeDesktopItem, libxslt, file
, wrapGAppsHook, hicolor-icon-theme, gsettings-desktop-schemas, glib }:

let

  version = "2006";

  build1 = "8.0.0";

  build2 = "16522670";

  cart = "CART21FQ2";

  meta = {
    license = stdenv.lib.licenses.unfree;
    homepage = "https://www.vmware.com/go/viewclients";
    description =
      "Allows you to connect to your VMware Horizon virtual desktop";
    platforms = stdenv.lib.platforms.linux;
  };

  vmwareBundle64 = fetchurl {
    url =
      "https://download3.vmware.com/software/view/viewclients/${cart}/VMware-Horizon-Client-${version}-${build1}-${build2}.x64.bundle";
    sha256 = "1kawm6wwjaajrvmi0wg5wlgjcsmc1x28s40h3715cs9i800kkakp";
  };

  vmwareBundleUnpacker = fetchurl {
    url =
      "https://sources.gentoo.org/proj/vmware.git/plain/eclass/vmware-bundle.eclass";
    sha256 = "0crh8c6mx385pr4dz2z6gx5zgyd3gjj185z8r1pm1z4ip293x1nn";
  };

  vmwareBundle = if stdenv.hostPlatform.system == "x86_64-linux" then
    vmwareBundle64
  else
    throw "Unsupported system: ${stdenv.hostPlatform.system}";

  vmwareHorizonClientFiles = stdenv.mkDerivation {
    name = "vmwareHorizonClientFiles";

    inherit meta version;

    src = vmwareBundle;

    buildInputs = [ hicolor-icon-theme gsettings-desktop-schemas glib ];

    nativeBuildInputs = [ libxslt file wrapGAppsHook ];

    unpackPhase = ''
      echo '
        ebegin() {
          echo "$1"
        }
        eend() {
          echo OK
        }
        source "${vmwareBundleUnpacker}"
        export T="$PWD"
        vmware-bundle_extract-bundle-component "$src" vmware-horizon-client ./ext-client
        vmware-bundle_extract-bundle-component "$src" vmware-horizon-pcoip ./ext-pcoip
        vmware-bundle_extract-bundle-component "$src" vmware-horizon-seamless-window ./ext-seamless
      ' >extractor.sh
      bash extractor.sh
    '';

    installPhase = ''
      mkdir "$out"

      cp -a ./ext-client/bin "$out/"
      cp -a ./ext-client/lib "$out/"
      cp -a ./ext-client/share "$out/"
      cp -a ./ext-pcoip/pcoip/lib "$out/"
      cp -a ./ext-seamless/lib "$out/"

      for FILE in $(find "$out" -type f); do
        file --mime "$FILE" | egrep -q "(application/x-(pie-)?(executable|sharedlib)|text/x-shellscript)" || continue
        chmod +x "$FILE"
      done
    '';
  };

  desktopItem = makeDesktopItem {
    name = "vmware-horizon-client";
    exec = "vmware-horizon-client";
    icon = "${vmwareHorizonClientFiles}/share/icons/vmware-view.png";
    desktopName = "VMware Horizon Client";
    genericName = "VMware Horizon Client";
  };

in buildFHSUserEnv {
  name = "vmware-horizon-client";

  inherit meta;

  targetPkgs = pkgs:
    with pkgs; [
      vmwareHorizonClientFiles

      glibc.bin
      binutils-unwrapped

      atk
      at-spi2-atk
      cairo
      dbus
      gdk-pixbuf
      glib
      gtk3
      harfbuzz
      libtiff
      libudev0-shim
      libuuid
      libxml2
      pango
      pixman
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      xorg.libxkbfile
      xorg.libXrandr
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXtst
      zlib
    ];

  runScript = "${vmwareHorizonClientFiles}/bin/vmware-view";

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}"/share/applications/* $out/share/applications/
  '';
}
