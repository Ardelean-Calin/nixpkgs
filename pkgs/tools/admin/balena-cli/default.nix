{ lib
, stdenv
, buildNpmPackage
, overrideSDK
, fetchFromGitHub
, testers
, balena-cli
, nodePackages
, python3
, udev
, cctools
, darwin
}:

let
  # Fix for: https://github.com/NixOS/nixpkgs/issues/272156
  buildNpmPackage' = buildNpmPackage.override {
    stdenv = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };
in buildNpmPackage' rec {
  pname = "balena-cli";
  version = "18.2.29";

  src = fetchFromGitHub {
    owner = "balena-io";
    repo = "balena-cli";
    rev = "v${version}";
    hash = "sha256-y2dlyu/JEWeNQ8yBVO5pNwm3qnVe3BLAeW5poyOu0+A=";
  };

  npmDepsHash = "sha256-01w+fyepZbxpN3NvtXWYZDPsIbT6jm3DGNbJ6Ibm0dQ=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';
  makeCacheWritable = true;

  nativeBuildInputs = [
    nodePackages.node-gyp
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    cctools
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Cocoa
  ];

  passthru.tests.version = testers.testVersion {
    package = balena-cli;
    command = ''
      # Override default cache directory so Balena CLI's unavoidable update check does not fail due to write permissions
      BALENARC_DATA_DIRECTORY=./ balena --version
    '';
    inherit version;
  };

  meta = with lib; {
    description = "Command line interface for balenaCloud or openBalena";
    longDescription = ''
      The balena CLI is a Command Line Interface for balenaCloud or openBalena. It is a software
      tool available for Windows, macOS and Linux, used through a command prompt / terminal window.
      It can be used interactively or invoked in scripts. The balena CLI builds on the balena API
      and the balena SDK, and can also be directly imported in Node.js applications.
    '';
    homepage = "https://github.com/balena-io/balena-cli";
    changelog = "https://github.com/balena-io/balena-cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ maintainers.kalebpace maintainers.doronbehar ];
    mainProgram = "balena";
  };
}
