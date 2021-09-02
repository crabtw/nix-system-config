{ pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    haskellPackages.wawabook
  ];

  systemd.user.startServices = true;

  services.today-books = {
    enable = true;
    dates = "19:00:00";
    delay = "30min";
  };

  programs.tmux.extraConfig =  ''
    new  -n irc
    neww -n wawabook -c ~/db/wawabook
    neww -n nix-system-config -c ~/src/nix-system-config
    neww -n nixpkgs -c ~/src/nixpkgs
    neww -n ats-xanadu -c ~/src/ATS-Xanadu/
    neww -n rust -c ~/src/rust/
    neww -n ocaml -c ~/src/ocaml/
    neww -n idris2 -c ~/src/Idris2/
    neww -n gcc -c ~/src/gcc
    neww -n llvm -c ~/src/llvm-project
    neww -n fstar -c ~/src/FStar
    neww -n z3 -c ~/src/z3
    neww -n ghc -c ~/src/ghc
    neww -n wasmtime -c ~/src/wasmtime
    neww -n compcert -c ~/src/CompCert
    neww -n sail -c ~/src/sail
    neww -n grin -c ~/src/grin
    neww -n regalloc2 -c ~/src/regalloc2
    neww -n zig -c ~/src/zig

    neww -c ~/
    selectw -t 0
  '';
}
