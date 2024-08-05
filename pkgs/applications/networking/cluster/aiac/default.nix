{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aiac";
  version = "5.0.1";
  excludedPackages = [".ci"];

  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1kWXvmnfdx44HYjW3vHuj2oU1uMabeGcZutkpszWg7Y=";
  };

  vendorHash = "sha256-uXYin6JITpy3bc7FI/3aJqvCD9cGwGL1qjB8hBUWLQE=";
  ldflags = [ "-s" "-w" "-X github.com/gofireflyio/aiac/v4/libaiac.Version=v${version}" ];

  meta = with lib; {
    description = ''Artificial Intelligence Infrastructure-as-Code Generator.'';
    mainProgram = "aiac";
    homepage = "https://github.com/gofireflyio/aiac/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
