{ lib, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-extra

    opendesktop-fonts
    wqy_microhei
    wqy_unibit
    ipafont
    ipaexfont

    dejavu_fonts
    freefont_ttf
    liberation_ttf

    inconsolata-nerdfont
  ];

  fonts.fontconfig.useEmbeddedBitmaps = true;

  fonts.fontconfig.localConf = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>

    ${lib.concatMapStringsSep "\n" lib.readFile
      [ ./noto-fonts.conf
        ./wqy-unibit.conf
      ]}

    </fontconfig>
  '';
}
