{ stdenv, fetchurl }:

let

  version = "10.4.3";

in
stdenv.mkDerivation {
  pname = "wstunnel-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-OE9LStAsQD/afbilvXaO7vSvKP7pXfPBo5ej1juWf5g=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D -m755 wstunnel $out/bin/wstunnel
  '';

  meta = {
    mainProgram = "wstunnel";
  };
}
