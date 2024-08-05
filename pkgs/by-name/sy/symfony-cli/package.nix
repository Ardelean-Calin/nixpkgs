{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
, testers
, symfony-cli
, nssTools
, makeBinaryWrapper
}:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.10.2";
  vendorHash = "sha256-WSZM/9inaFLlZIAwH3E8hWyRQaOvY8BJ6ECpbkqJN6g=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-/fJ9Ovk2gXCIvvieCXxnI8gDjwrhQHJoF3Ia47dSdgQ=";
    leaveDotGit = true;
    postFetch = ''
      git --git-dir $out/.git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      rm -rf $out/.git
    '';
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  preBuild = ''
    ldflags+=" -X main.buildDate=$(cat SOURCE_DATE)"
  '';

  buildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mkdir $out/libexec
    mv $out/bin/symfony-cli $out/libexec/symfony

    makeBinaryWrapper $out/libexec/symfony $out/bin/symfony \
      --prefix PATH : ${lib.makeBinPath [ nssTools ]}
  '';

  # Tests requires network access
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = symfony-cli;
      command = "symfony version --no-ansi";
    };
  };

  meta = {
    changelog = "https://github.com/symfony-cli/symfony-cli/releases/tag/v${version}";
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
