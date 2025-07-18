{
  stdenv,
  lib,
  buildFHSEnv,
  copyDesktopItems,
  fetchurl,
  gsettings-desktop-schemas,
  makeDesktopItem,
  makeWrapper,
  opensc,
  writeTextDir,
  configText ? "",
}:
let
  version = "2406";

  sysArch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x64"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
  # The downloaded archive also contains ARM binaries, but these have not been tested.

  # For USB support, ensure that /var/run/vmware/<YOUR-UID>
  # exists and is owned by you. Then run vmware-usbarbitrator as root.

  mainProgram = "vmware-view";

  # This forces the default GTK theme (Adwaita) because Horizon is prone to
  # UI usability issues when using non-default themes, such as Adwaita-dark.
  wrapBinCommands = path: name: ''
    makeWrapper "$out/${path}/${name}" "$out/bin/${name}_wrapper" \
    --set GTK_THEME Adwaita \
    --suffix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
    --suffix LD_LIBRARY_PATH : "$out/lib/vmware/view/crtbora:$out/lib/vmware"
  '';

  vmwareHorizonClientFiles = stdenv.mkDerivation {
    pname = "vmware-horizon-files";
    inherit version;
    src = fetchurl {
      url = "https://download3.omnissa.com/software/CART25FQ2_LIN_2406_TARBALL/VMware-Horizon-Client-Linux-2406-8.13.0-9995429239.tar.gz";
      sha256 = "d6bae5cea83c418bf3a9cb884a7d8351d8499f1858a1ac282fd79dc0c64e83f6";
    };
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir ext
      find ${sysArch} -type f -print0 | xargs -0n1 tar -Cext --strip-components=1 -xf

      chmod -R u+w ext/usr/lib
      mv ext/usr $out
      cp -r ext/${sysArch}/include $out/
      cp -r ext/${sysArch}/lib $out/

      # Horizon includes a copy of libstdc++ which is loaded via $LD_LIBRARY_PATH
      # when it cannot detect a new enough version already present on the system.
      # The checks are distribution-specific and do not function correctly on NixOS.
      # Deleting the bundled library is the simplest way to force it to use our version.
      rm "$out/lib/vmware/gcc/libstdc++.so.6"

      # This bundled version of libpng causes browser issues, and would prevent web-based sign-on.
      rm "$out/lib/vmware/libpng16.so.16"

      # This opensc library is required to support smartcard authentication during the
      # initial connection to Horizon.
      mkdir $out/lib/vmware/view/pkcs11
      ln -s ${opensc}/lib/pkcs11/opensc-pkcs11.so $out/lib/vmware/view/pkcs11/libopenscpkcs11.so

      ${wrapBinCommands "bin" "vmware-view"}
      ${wrapBinCommands "lib/vmware/view/usb" "vmware-eucusbarbitrator"}
    '';
  };

  libxml2' = pkgs: pkgs.libxml2.overrideAttrs rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
  };

  vmwareFHSUserEnv =
    pname:
    buildFHSEnv {
      inherit pname version;

      runScript = "${vmwareHorizonClientFiles}/bin/${pname}_wrapper";

      targetPkgs =
        pkgs: with pkgs; [
          at-spi2-atk
          atk
          cairo
          dbus
          file
          fontconfig
          freetype
          gdk-pixbuf
          glib
          gtk2
          gtk3-x11
          harfbuzz
          liberation_ttf
          libjpeg
          libpng
          libpulseaudio
          libtiff
          libudev0-shim
          libuuid
          libv4l
          (libxml2' pkgs)
          pango
          pcsclite
          pixman
          udev
          vmwareHorizonClientFiles
          xorg.libX11
          xorg.libXau
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

          (writeTextDir "etc/vmware/config" configText)
        ];
    };

  desktopItem = makeDesktopItem {
    name = "vmware-view";
    desktopName = "VMware Horizon Client";
    icon = "${vmwareHorizonClientFiles}/share/icons/vmware-view.png";
    exec = "${vmwareFHSUserEnv mainProgram}/bin/${mainProgram} %u";
    mimeTypes = [ "x-scheme-handler/vmware-view" ];
  };

in
stdenv.mkDerivation {
  pname = "vmware-horizon-client";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${vmwareFHSUserEnv "vmware-view"}/bin/vmware-view $out/bin/
    ln -s ${vmwareFHSUserEnv "vmware-usbarbitrator"}/bin/vmware-usbarbitrator $out/bin/
    runHook postInstall
  '';

  unwrapped = vmwareHorizonClientFiles;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    inherit mainProgram;
    description = "Allows you to connect to your VMware Horizon virtual desktop";
    homepage = "https://www.vmware.com/go/viewclients";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
