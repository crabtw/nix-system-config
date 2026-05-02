{
  stdenv,
  fetchurl,
  zstd,
}:

let

  version = "0.1.0";

in
stdenv.mkDerivation {
  pname = "wawabook-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/crabtw/wawabook/releases/download/v${version}/wawabook-v${version}-x86_64-unknown-linux-musl.tar.zstd";
    hash = "sha256-Iv7n7c8VFKOBo/Whc7Hpsui9DHod8QHeFjWaf2RqlCk=";
  };

  nativeBuildInputs = [ zstd ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D -m755 wawabook $out/bin/wawabook
  '';

  meta = {
    mainProgram = "wawabook";
  };
}
