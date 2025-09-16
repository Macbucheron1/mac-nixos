{ lib, fetchFromGitHub, python3Packages, xorg, stdenv }:

python3Packages.buildPythonApplication rec {
  pname = "exegol";
  version = "5.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThePorgs";
    repo = "Exegol";
    tag = version;
    hash = "sha256-eoOCVYKHWPsaSxdOF3FTg6dS5JdTSlfNTM6Hrf6KTlc=";
  };

  build-system = with python3Packages; [ pdm-backend ];

  pythonRelaxDeps = [ "rich" "argcomplete" "supabase" ];

  dependencies = with python3Packages; [
    argcomplete cryptography docker gitpython ifaddr pydantic pyjwt pyyaml
    requests rich supabase
  ] ++ pyjwt.optional-dependencies.crypto
    ++ [ xorg.xhost ]
    ++ lib.optional (!stdenv.hostPlatform.isLinux) tzlocal;

  doCheck = true;
  pythonImportsCheck = [ "exegol" ];

  meta = with lib; {
    description = "Fully featured and community-driven hacking environment";
    homepage = "https://github.com/ThePorgs/Exegol";
    changelog = "https://github.com/ThePorgs/Exegol/releases/tag/${version}";
    license = [
      licenses.gpl3Only
      {
        fullName = "Exegol Software License (ESL) - Version 1.0";
        url = "https://docs.exegol.com/legal/software-license";
        free = false; redistributable = false;
      }
    ];
    mainProgram = "exegol";
  };
}
