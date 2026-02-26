{ ... }:
final: prev: {
  python313Packages = prev.python313Packages.overrideScope (pyFinal: pyPrev: {
    iceberg-python = pyPrev.iceberg-python.overridePythonAttrs (old: {
      doCheck = false;
    });
  });
}
