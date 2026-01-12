{
  lib,
  buildPythonPackage,
  fetchPypi,
  anyio,
  httpx,
  pydantic,
  pyjwt,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "supabase-auth";
  version = "2.27.0";
  pyproject = true;

  src = fetchPypi {
    pname = "supabase_auth";
    inherit version;
    hash = "sha256-sk4VoH9ldEfaok9h3T2m/7LzdOG8UfonJREw4MjjwBA=";
  };

  build-system = [ uv-build ];

  dependencies = [
    anyio
    httpx
    pydantic
    pyjwt
    typing-extensions
  ];

  pythonImportsCheck = [ "supabase_auth" ];

  # Upstream pins `uv_build>=0.8.3,<0.9.0`, but nixpkgs ships `uv-build` 0.9.x.
  # Relax the upper bound to accept the 0.9 series, consistent with uv’s documentation examples:
  # https://docs.astral.sh/uv/concepts/build-backend/#using-the-uv-build-backend
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3,<0.10.0'
  '';

  # Upstream tests require Docker-based Supabase Auth integration containers, which are unavailable in the Nix build sandbox.
  doCheck = false;

  meta = {
    description = "Client library for Supabase Auth";
    homepage = "https://github.com/supabase/supabase-py/";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}

