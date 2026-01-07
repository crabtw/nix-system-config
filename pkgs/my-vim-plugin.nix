{ buildVimPlugin, fetchFromGitHub }:

buildVimPlugin {
  pname = "my-vim";
  version = "2026-01-07";
  src = fetchFromGitHub {
    owner = "crabtw";
    repo = "my.vim";
    rev = "dfc39b2afcd50c02ab153373a44cb0e3a5e23664";
    hash = "sha256-soOMifDqhweFsGfSI/gO7oct5wPZt46OIyMgc4RN/bo=";
  };
}
