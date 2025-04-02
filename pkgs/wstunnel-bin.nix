{ stdenv, fetchurl }:

let

  version = "10.1.5";

in
stdenv.mkDerivation {
  pname = "wstunnel-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/erebe/wstunnel/releases/download/v${version}/wstunnel_${version}_linux_amd64.tar.gz";
    hash = "sha256-xlDkwei+1Ir4v/6uJt6shhcJvZtOvS/aC/ZDF0TsbDM=";
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
