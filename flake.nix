{
  inputs.flox-floxpkgs.url = "github:flox/floxpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = inputs:
    inputs.flox-floxpkgs.project inputs
    (_: {
      packages.mypython = {
        poetry2nix,
        python3Packages,
        rustPlatform,
        pkgs,
      }:
        poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          overrides =
            poetry2nix.overrides.withDefaults
            (self: super: {
              tweedledum =
                super.tweedledum.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.scikit-build];
                    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
                    dontUseCmakeConfigure = true;
                  }
                );
              ruff =
                super.ruff.overridePythonAttrs
                (
                  old: let
                    pname = "ruff";
                    version = "0.0.244";
                    src = pkgs.fetchFromGitHub {
                      owner = "charliermarsh";
                      repo = pname;
                      rev = "v${version}";
                      sha256 = "sha256-oQBNVs7hoiXNqz5lYq5YNKHfpQ/c8LZAvNvtFqpTM2E=";
                    };
                  in {
                    inherit src;
                    cargoDeps = rustPlatform.fetchCargoTarball {
                      src = src;
                      name = "${pname}-${version}";
                      hash = "sha256-61kypAXWfUZLfTbSp+b0gCKwuWtxAYVtKIwfVOcJ2o8=";
                    };
                    format = "pyproject";
                    nativeBuildInputs =
                      old.nativeBuildInputs
                      ++ (with pkgs;
                        with rustPlatform; [
                          installShellFiles
                          cargoSetupHook
                          maturinBuildHook
                          rust.cargo
                          rust.rustc
                        ]);
                    buildInputs = (old.buildInputs or []) ++ [self.setuptools];
                  }
                );
              pathspec =
                super.pathspec.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.flit-core];
                  }
                );
              pyscf =
                super.pyscf.overridePythonAttrs
                (
                  old: {
                    patches = [
                      (pkgs.fetchpatch {
                        name = "libxc-6"; # https://github.com/pyscf/pyscf/pull/1467
                        url = "https://github.com/pyscf/pyscf/commit/ebcfacc90e119cd7f9dcdbf0076a84660349fc79.patch";
                        sha256 = "sha256-O+eDlUKJeThxQcHrMGqxjDfRCmCNP+OCgv/L72jAF/o=";
                      })
                    ];
                    buildInputs = (old.buildInputs or []) ++ [pkgs.blas pkgs.libxc pkgs.xcfun pkgs.libcint];
                    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
                    dontUseCmakeConfigure = true;
                    catchConflicts = false;
                    preConfigure = with pkgs; ''
                      export CMAKE_CONFIGURE_ARGS="-DBUILD_LIBCINT=0 -DBUILD_LIBXC=0 -DBUILD_XCFUN=0"
                      PYSCF_INC_DIR="${libcint}:${libxc}:${xcfun}";
                    '';
                  }
                );
              nevergrad =
                super.nevergrad.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools];
                  }
                );
              qiskit-aer =
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
                );
              qiskit-terra =
                super.qiskit-terra.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools-rust];
                    cargoRoot = "";
                    cargoDeps = pkgs.rustPlatform.importCargoLock {
                      lockFile = "${pkgs.fetchzip {
                        url = pkgs.lib.head old.src.urls;
                        sha256 = "sha256-q6XqcT5/989LmEJpReC6QhP8FLqu0BZQ0KvoNLVSmQo=";
                      }}/Cargo.lock";
                    };
                    nativeBuildInputs =
                      old.nativeBuildInputs
                      ++ (with rustPlatform; [
                        rust.rustc
                        rust.cargo
                        cargoSetupHook
                      ]);
                  }
                );
              optuna =
                super.optuna.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools];
                  }
                );
              cotengra =
                super.cotengra.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools];
                  }
                );
              matplotlib =
                super.matplotlib.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.pybind11];
                  }
                );
              symengine =
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
                );
              iniconfig =
                super.iniconfig.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.hatchling super.hatch-vcs];
                  }
                );
              qdldl =
                super.qdldl.overridePythonAttrs
                (
                  old: {
                    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
                    dontUseCmakeConfigure = true;
                  }
                );
              filelock =
                super.filelock.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools super.hatchling super.hatch-vcs];
                  }
                );
              rustworkx =
                super.rustworkx.overridePythonAttrs
                (
                  old: {
                    cargoRoot = "";
                    cargoDeps = pkgs.rustPlatform.importCargoLock {
                      lockFile = "${pkgs.fetchzip {
                        url = pkgs.lib.head old.src.urls;
                        sha256 = "sha256-Vd/qZHTeWA5QB+Q6L3JgfL/9+ZT+YWUFFXaeEsO02ug=";
                      }}/Cargo.lock";
                    };
                    nativeBuildInputs =
                      old.nativeBuildInputs
                      ++ (with rustPlatform; [
                        rust.rustc
                        rust.cargo
                        cargoSetupHook
                      ]);
                    buildInputs =
                      (old.buildInputs or [])
                      ++ [
                        super.setuptools
                        super.setuptools-rust
                      ];
                  }
                );
              cmaes =
                super.cmaes.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools];
                  }
                );
              virtualenv =
                super.virtualenv.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.hatchling super.hatch-vcs];
                  }
                );
              cryptography =
                super.cryptography.overridePythonAttrs
                (
                  old: {
                    cargoDeps = rustPlatform.fetchCargoTarball {
                      inherit (old) src;
                      name = "${old.pname}-${old.version}";
                      sourceRoot = "${old.pname}-${old.version}/src/rust/";
                      sha256 = "sha256-0x+KIqJznDEyIUqVuYfIESKmHBWfzirPeX2R/cWlngc=";
                    };
                    cargoRoot = "src/rust";
                    nativeBuildInputs =
                      old.nativeBuildInputs
                      ++ (with rustPlatform; [
                        rust.rustc
                        rust.cargo
                        cargoSetupHook
                      ]);
                  }
                );
              cvxopt =
                super.cvxopt.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools pkgs.lapack-reference pkgs.suitesparse];
                  }
                );
              autoray =
                super.autoray.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.setuptools];
                  }
                );
            });
        };
    });
}
