{ fetchzip }:

fetchzip rec {
  name = "wqy-unibit-bdf-1.1.0-1";

  url = "mirror://sourceforge/wqy/${name}.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    install -Dm644 *.bdf -t $out/share/fonts/
  '';

  sha256 = "1mh2xha071gsbrrnmlr6a4y9gc90qhdiil38kyrvdqn9qh62mvs4";
}
