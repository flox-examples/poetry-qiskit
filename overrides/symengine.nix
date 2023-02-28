super.symengine.overridePythonAttrs
(
  old: {
    buildInputs = (old.buildInputs or []) ++ [super.setuptools super.cython];
    patches = [
      (pkgs.fetchpatch {
        # setuptools 61 compat
        url = "https://github.com/symengine/symengine.py/commit/987e665e71cf92d1b021d7d573a1b9733408eecf.patch";
        hash = "sha256-2QbNdw/lKYRIRpOU5BiwF2kK+5Lh2j/Q82MKUIvl0+c=";
      })
    ];
    preBuild = ''
      CMAKE_PREFIX_PATH=${pkgs.symengine}:$CMAKE_PREFIX_PATH
    '';
    setupPyBuildFlags = [
      "--symengine-dir=${pkgs.symengine}/"
    ];
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
    dontUseCmakeConfigure = true;
  }
)
