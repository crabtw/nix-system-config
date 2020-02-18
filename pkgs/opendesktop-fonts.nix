{ fetchzip }:

let

  pname = "opendesktop-fonts";

  version = "1.4.2";

in

fetchzip rec {
  name = "${pname}-${version}";

  url = "https://sources.archlinux.org/other/${pname}/${name}.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    install -Dm644 *.ttf *.ttc -t $out/share/fonts/
  '';

  sha256 = "0paqpm9l9k8l429j1iq4vsk13zyxgrhay1qqj8jniq2fhfj67y88";
}
