{ buildVimPluginFrom2Nix, fetchFromGitHub }:

buildVimPluginFrom2Nix {
  pname = "my-vim";
  version = "2022-03-04";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "7e66073aa8326f742bca01f381d9cce6018bc856";
    sha256 = "03ifvqanysdaf6igzns8hcy1c3yzs97wxgpybsm44n2whm8prbvr";
  };
}
