{ stdenv, fetchurl }:

let

  version = "8.4.2";

in stdenv.mkDerivation {
  pname = "wstunnel-rs";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-pDPsguamo4cp6WstYi8io1J7pnbeJ6kmEc0KdzYaio0=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D -m755 wstunnel $out/bin/wstunnel
  '';
}
