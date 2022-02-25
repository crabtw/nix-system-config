{ buildVimPluginFrom2Nix, fetchFromGitHub }:

buildVimPluginFrom2Nix {
  pname = "my-vim";
  version = "2022-02-25";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "9b7817739ccc34d04a79b43d5be9aa182e1c49db";
    sha256 = "1z2mgabnazv1v69kry68qf7hd49wcgs24biraf3j9v77zbhah7y8";
  };
}
