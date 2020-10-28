{ buildVimPluginFrom2Nix, fetchFromGitHub }:

buildVimPluginFrom2Nix {
  pname = "my-vim";
  version = "2019-11-01";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "d5a78e78c5ee0479cf6c240155e3b5bd31f18619";
    sha256 = "191mib5k6q2bzmdmfjivykxzxd32k5ba7a957w9rncim6jqfri5k";
  };
}
