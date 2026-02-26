{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  uv-build,
  httpx,
  pydantic,
  yarl,
  pyiceberg,
  deprecation,
  pytest-asyncio,
  pytest-cov,
  python-dotenv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "storage3";
  version = "2.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-TRATa+lDRm2MDuARXfBRWnWYUak8i1fW7rr5ujWN8TY=";
  };

  sourceRoot = "${src.name}/src/storage";

  build-system = [ uv-build ];

  dependencies = [
    httpx
    pydantic
    yarl
    pyiceberg
    deprecation
  ]
  ++ httpx.optional-dependencies.http2;

  # Upstream pins `uv_build>=0.8.3,<0.9.0`, but nixpkgs ships `uv-build` 0.9.x.
  # Relax the upper bound to accept the 0.9 series, consistent with uv’s documentation examples:
  # https://docs.astral.sh/uv/concepts/build-backend/#using-the-uv-build-backend
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';


  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
    python-dotenv
  ];

  pythonImportsCheck = [ "storage3" ];

  disabledTestPaths = [
    "tests/_sync/"
    "tests/_async/"
  ];

  meta = {
    description = "Client library for Supabase Functions";
    homepage = "https://github.com/supabase/supabase-py";
    changelog = "https://github.com/supabase/supabase-py/blob/v${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ macbucheron ];
    license = lib.licenses.mit;
  };
}
