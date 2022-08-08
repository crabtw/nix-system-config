{ buildVimPluginFrom2Nix, fetchFromGitHub }:

buildVimPluginFrom2Nix {
  pname = "my-vim";
  version = "2022-08-08";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "add020f2ba63fd699b7136149c4729cebef1246d";
    sha256 = "017f5kgn0yn5i00sgzacfyipzknvpy2hsslyihb1a2din4zqfygz";
  };
}
