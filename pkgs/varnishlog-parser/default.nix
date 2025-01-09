{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "varnishlog-parser";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "aorith";
    repo = "varnishlog-parser";
    rev = "v${version}";
    sha256 = "sha256-78Rk9SnCk5Hq5BC+6WgRb0aeUTcKY+K8+rLx1/gIv/Q=";
  };

  vendorHash = "sha256-84hpEJPYS4z3dnXye+gYx1dx199tlcV5Gbzykq3HFlE=";

  meta = with lib; {
    description = "A varnishlog parser library and web user interface";
    homepage = "https://github.com/aorith/varnishlog-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ aorith ];
    platforms = platforms.unix;
    mainProgram = "varnishlog-parser";
  };
}
