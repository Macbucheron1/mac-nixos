{ lib, fetchFromGitHub, python3Packages, xorg, stdenv }:
let
supabase-auth = python3Packages.buildPythonPackage rec {
  pname = "supabase-auth";
  version = "2.23.0";
  pyproject = true;

  src = python3Packages.fetchPypi {
    pname = "supabase_auth";
    inherit version;
    hash = "sha256-4AiXzJE8ehv04ni+5U4g5a5Vh7XV1hhEhNTTdLYTOwQ=";
  };

  # uv_build est pin <0.9.0 upstream, mais nixpkgs peut fournir 0.9.x
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  build-system = [ python3Packages."uv-build" ];
  nativeBuildInputs = [ python3Packages."uv-build" ];

  dependencies = with python3Packages; [
    pydantic httpx anyio typing-extensions pyjwt
  ];

  pythonRelaxDeps = [ "pydantic" "uv_build" ];

  doCheck = false;
  pythonImportsCheck = [ "supabase_auth" ];
};

supabase-functions = python3Packages.buildPythonPackage rec {
  pname = "supabase-functions";
  version = "2.23.0";
  pyproject = true;

  src = python3Packages.fetchPypi {
    pname = "supabase_functions";
    inherit version;
    hash = "sha256-ehcLTvWOsqPuPqSO6SyXI3yvs7QdPB1c2m7j+kqFVCw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  build-system = [ python3Packages."uv-build" ];
  nativeBuildInputs = [ python3Packages."uv-build" ];

  dependencies = with python3Packages; [
    httpx anyio typing-extensions pydantic strenum yarl
  ];

  pythonRelaxDeps = [ "pydantic" "uv_build" ];

  doCheck = false;
  pythonImportsCheck = [ "supabase_functions" ];
};
in
python3Packages.buildPythonApplication rec {
  pname = "exegol";
  version = "5.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThePorgs";
    repo = "Exegol";
    tag = version;
    hash = "sha256-t3nZcr7Gp/HBuXPe4KN+QPSPgsQfwkt3wkKAQ9ZDihc=";
  };

  build-system = with python3Packages; [ pdm-backend ];

  pythonRelaxDeps = [
    "rich" "argcomplete" "supabase" "supabase-auth" "supabase-functions"
    "requests" "pyyaml" "pydantic" "cryptography"
  ];

  dependencies = with python3Packages; [
    argcomplete cryptography docker gitpython ifaddr pydantic pyjwt pyyaml
    requests rich supabase supabase-auth supabase-functions
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
