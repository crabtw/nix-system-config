{
  pkgs,
  stdenv,
  callPackage,
  hsPkgs,
}:

let

  inherit (pkgs.haskell.lib) unmarkBroken overrideCabal;

in

{
  gipeda =
    callPackage
      (
        {
          mkDerivation,
          aeson,
          base,
          bytestring,
          cassava,
          concurrent-output,
          containers,
          directory,
          extra,
          file-embed,
          filepath,
          gitlib,
          gitlib-libgit2,
          scientific,
          shake,
          split,
          stdenv,
          tagged,
          text,
          transformers,
          unordered-containers,
          vector,
          yaml,
          fetchFromGitHub,
          makeWrapper,
          makeBinPath,
          runtimeShell,
          coreutilsBin,
          wgetBin,
          unzipBin,
          gitBin,
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
            let
              path = makeBinPath [
                coreutilsBin
                wgetBin
                unzipBin
                gitBin
              ];
            in
            ''
              wrapProgram $out/bin/gipeda \
                --prefix PATH : "${path}"
            '';
          isLibrary = false;
          isExecutable = true;
          executableHaskellDepends = [
            aeson
            base
            bytestring
            cassava
            concurrent-output
            containers
            directory
            extra
            file-embed
            filepath
            gitlib
            gitlib-libgit2
            scientific
            shake
            split
            tagged
            text
            transformers
            unordered-containers
            vector
            yaml
          ];
          homepage = "https://github.com/nomeata/gipeda";
          description = "Git Performance Dashboard";
          license = pkgs.lib.licenses.mit;
        }
      )
      {
        inherit (pkgs.lib) makeBinPath;
        inherit (pkgs) runtimeShell;
        coreutilsBin = pkgs.coreutils;
        wgetBin = pkgs.wget;
        unzipBin = pkgs.unzip;
        gitBin = pkgs.git;
      };
}
