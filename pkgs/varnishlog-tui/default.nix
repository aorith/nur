{
  system ? builtins.currentSystem,
  lib,
  fetchurl,
  stdenvNoCC,
}: let
  values = import ./values.nix;
  version = values.version;
  shaMap = values.shaMap;
  urlMap = values.urlMap;
in
  stdenvNoCC.mkDerivation {
    pname = "varnishlog-tui";
    version = version;
    src = fetchurl {
      url = urlMap.${system};
      sha256 = shaMap.${system};
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      cp -vr ./varnishlog-tui $out/bin/varnishlog-tui
    '';

    system = system;

    meta = {
      description = "A Varnishlog TUI";
      homepage = "https://github.com/aorith/varnishlog-tui";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [aorith];
      platforms = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
      mainProgram = "varnishlog-tui";
    };
  }
