{ stdenv, fetchurl }:

let

  version = "11.1.0";

in
stdenv.mkDerivation {
  pname = "wstunnel-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-US7fTnu2T8EzUiIgEjUUho+udbW65BJLU+OWeHJ2qiM=";
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
