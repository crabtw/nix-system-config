{ lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    opendesktop-fonts
    wqy_microhei
    wqy_unibit
    ipafont
    ipaexfont

    dejavu_fonts
    freefont_ttf
    liberation_ttf

    nerd-fonts.inconsolata
  ];

  fonts.fontconfig.useEmbeddedBitmaps = true;

  fonts.fontconfig.localConf = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

    ${lib.concatMapStringsSep "\n" lib.readFile [
      ./noto-fonts.conf
      ./wqy-unibit.conf
    ]}

    </fontconfig>
  '';
}
