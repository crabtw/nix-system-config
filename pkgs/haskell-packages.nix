{ pkgs, stdenv, callPackage, hsPkgs }:

let

  inherit (pkgs.haskell.lib) unmarkBroken overrideCabal;

in

{
  wawabook = callPackage (
    { mkDerivation, base, bytestring, conduit, http-conduit, resourcet
    , stdenv, tagsoup, time, transformers
    , fetchFromGitHub
    }:
    mkDerivation {
      pname = "wawabook";
      version = "0.1.0.0";
      src = fetchFromGitHub {
        owner = "crabtw";
        repo = "wawabook";
        rev = "f11823e50d6174ca1e450bc7a76b249c06d1362f";
        sha256 = "1rggi3amyrbnyilaflsq0zs7w4q36ganpzyh6sjqh1gqsaik5yvv";
      };
      isLibrary = false;
      isExecutable = true;
      executableHaskellDepends = [
        base bytestring conduit http-conduit resourcet tagsoup time
        transformers
      ];
      description = "A HTML scraper for wawabook.com.tw";
      license = pkgs.lib.licenses.asl20;
    }
  ) {};

  gipeda = callPackage (
    { mkDerivation, aeson, base, bytestring, cassava, concurrent-output
    , containers, directory, extra, file-embed, filepath, gitlib
    , gitlib-libgit2, scientific, shake, split, stdenv, tagged, text
    , transformers, unordered-containers, vector, yaml
    , fetchFromGitHub, makeWrapper, makeBinPath
    , runtimeShell, coreutilsBin, wgetBin, unzipBin, gitBin
    }:
    mkDerivation {
      pname = "gipeda";
      version = "0.3.3.2";
      src = fetchFromGitHub {
        owner = "crabtw";
        repo = "gipeda";
        rev = "b114c276de960fad656eab5681f784b8d744a5ca";
        sha256 = "1kirzqg6pcx77kv9jv5zdrzm83cn04qwh7hlc3as1nzcrlx7k7az";
      };
      buildTools = [ makeWrapper ];
      postPatch = ''
        substituteInPlace ./install-jslibs.sh \
          --replace /bin/bash "${runtimeShell}"
      '';
      postInstall =
        let path = makeBinPath [ coreutilsBin wgetBin unzipBin gitBin ]; in ''
        wrapProgram $out/bin/gipeda \
          --prefix PATH : "${path}"
      '';
      isLibrary = false;
      isExecutable = true;
      executableHaskellDepends = [
        aeson base bytestring cassava concurrent-output containers
        directory extra file-embed filepath gitlib gitlib-libgit2
        scientific shake split tagged text transformers
        unordered-containers vector yaml
      ];
      homepage = "https://github.com/nomeata/gipeda";
      description = "Git Performance Dashboard";
      license = pkgs.lib.licenses.mit;
    }
  ) {
    inherit (pkgs.lib) makeBinPath;
    inherit (pkgs) runtimeShell;
    coreutilsBin = pkgs.coreutils;
    wgetBin = pkgs.wget;
    unzipBin = pkgs.unzip;
    gitBin = pkgs.git;
  };

  gitlib = unmarkBroken hsPkgs.gitlib;

  gitlib-libgit2 = unmarkBroken hsPkgs.gitlib-libgit2;

  gitlib-test = unmarkBroken hsPkgs.gitlib-test;
}
