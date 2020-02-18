{ fetchzip }:

let

  pname = "ipamonafont";

  version = "1.0.8";

in

fetchzip {
  name = "${pname}-${version}";

  url = "https://web.archive.org/web/20190326123924/http://www.geocities.jp/ipa_mona/opfc-ModuleHP-1.1.1_withIPAMonaFonts-${version}.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    install -Dm644 fonts/*.ttf -t $out/share/fonts/
  '';

  sha256 = "1j0rgw7sxymi9sldg0fqzlvy021bwj5sghsxbsm5jvkg71wdcagc";
}
