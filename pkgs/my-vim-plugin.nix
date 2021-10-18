{ buildVimPluginFrom2Nix, fetchFromGitHub }:

buildVimPluginFrom2Nix {
  pname = "my-vim";
  version = "2021-03-22";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "fa2f719f3d4abdcd1606096d22eef801227ee047";
    sha256 = "1f72yxy5x8s2kaxgq68b60wk5x86kqaxl3jxddrix5y87z6zxqn6";
  };
}
