{ fetchzip }:

let version = "1.001"; in fetchzip {
  name = "noto-fonts-serif-cjk-${version}";

  url = "https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJK.ttc.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttc -d $out/share/fonts/noto
  '';

  sha256 = "0dxplp69cslmxrqh0jkfgbhkdbv3xi36jj4v9wfa4hjm9bpgwnf4";
}
