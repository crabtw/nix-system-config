{ stdenv, fetchurl }:

let

  version = "8.3.0";

in stdenv.mkDerivation {
  pname = "wstunnel-rs";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-fNoU3AS7cx8JiA22MQydnU7pYXaTFifzIuxyXN5r0Ys=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D -m755 wstunnel $out/bin/wstunnel
  '';
}
