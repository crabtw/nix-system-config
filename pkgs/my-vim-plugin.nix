{ buildVimPluginFrom2Nix, fetchFromGitHub }:

buildVimPluginFrom2Nix {
  pname = "my-vim";
  version = "2021-03-22";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "8537b47e55af440e0110abfefa4d632afc74c59b";
    sha256 = "01xp98752489j5v8dakd32kfp8v86bnw1s1rgwj312fqn7vjd3ic";
  };
}
