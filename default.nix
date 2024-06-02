# nix-build -A mypackage
{pkgs ? import <nixpkgs> {}}: {
  varnishlog-tui = pkgs.callPackage ./pkgs/varnishlog-tui {};
}
