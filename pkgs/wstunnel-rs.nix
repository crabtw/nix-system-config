{ stdenv, fetchurl }:

let

  version = "9.0.0";

in stdenv.mkDerivation {
  pname = "wstunnel-rs";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-Zi7puK867+stiDHNs9YVtal3V6quAswYxwtw+BpRxow=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D -m755 wstunnel $out/bin/wstunnel
  '';
}
