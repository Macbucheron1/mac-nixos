{ lib, fetchFromGitHub, python3Packages, xorg, stdenv }:

python3Packages.buildPythonApplication rec {
  pname = "exegol";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThePorgs";
    repo = "Exegol";
    tag = version;
    hash = "sha256-q84uWxVooQ+tFA2NhQ5N30h8LPhT+fJfxVmcpMzOQVk=";
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
