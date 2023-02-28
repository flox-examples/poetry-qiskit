super.qiskit-aer.overridePythonAttrs
(
  old: {
    postPatch = ''
      substituteInPlace setup.py \
        --replace "'cmake!=3.17,!=3.17.0'," "" \
        --replace "'pybind11', min_version='2.6'" "'pybind11'" \
        --replace "pybind11>=2.6" "pybind11" \
        --replace "scikit-build>=0.11.0" "scikit-build" \
        --replace "min_version='0.11.0'" ""
    '';
    PIP_DISABLE_PIP_VERSION_CHECK = 1;
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
    buildInputs =
      (old.buildInputs or [])
      ++ [
        super.scikit-build
        pkgs.cmake
        pkgs.nlohmann_json
        pkgs.spdlog
        pkgs.openblas
        pkgs.muparserx
        pkgs.catch2
      ];
    dontUseCmakeConfigure = true;
    doCheck = false;
    preConfigure = ''
      export DISABLE_CONAN=1
    '';
  }
)
