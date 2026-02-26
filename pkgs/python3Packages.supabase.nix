{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  realtime,
  supabase-functions,
  supabase-auth,
  postgrest,
  httpx,
  yarl,
  storage3,
}:

buildPythonPackage rec {
  pname = "supabase";
  version = "2.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-TRATa+lDRm2MDuARXfBRWnWYUak8i1fW7rr5ujWN8TY=";
  };

  sourceRoot = "${src.name}/src/supabase";

  build-system = [ uv-build ];

  pythonRelaxDeps = false;

  dependencies = [
    realtime
    supabase-auth
    supabase-functions
    postgrest
    httpx
    yarl
    storage3
  ];

  nativeBuildInputs = [
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  pythonImportsCheck = [ "supabase" ];

  meta = {
    homepage = "https://github.com/supabase/supabase-py";
    license = lib.licenses.mit;
    description = "Supabas client for Python";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
