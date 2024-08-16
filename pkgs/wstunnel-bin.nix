{ stdenv, fetchurl }:

let

  version = "10.0.1";

in stdenv.mkDerivation {
  pname = "wstunnel-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-gIucG/YlM60oqvVWiC+HSbvgM5puy3MckMBrWlG5HH8=";
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
