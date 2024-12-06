{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "varnishlog-parser";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "aorith";
    repo = "varnishlog-parser";
    rev = "v${version}";
    sha256 = "sha256-Jl36MDqQF4m2V2Z2uj84slUR5ZLbn0LgW4wPD4UlvEY=";
  };

  vendorHash = "sha256-y7y3YIJJMYcubdJm9lIiLeucEKYPnU3Dw0gVYZCDNYI=";

  meta = with lib; {
    description = "A varnishlog parser library and web user interface";
    homepage = "https://github.com/aorith/varnishlog-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ aorith ];
    platforms = platforms.unix;
    mainProgram = "varnishlog-parser";
  };
}
