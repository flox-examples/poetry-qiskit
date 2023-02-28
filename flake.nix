{
  inputs.flox-floxpkgs.url = "github:flox/floxpkgs";

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
            (self: super: let
              # Helper function
              extraBuildInputs = super: extras:
                super.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ extras;
                  }
                );
            in {
              # Complex overrides
              ruff = builtins.scopedImport {inherit super pkgs;} ./overrides/ruff.nix;
              pyscf = builtins.scopedImport {inherit super pkgs;} ./overrides/pyscf.nix;
              qiskit-aer = builtins.scopedImport {inherit super pkgs;} ./overrides/qiskit-aer.nix;
              qiskit-terra = builtins.scopedImport {inherit super pkgs;} ./overrides/qiskit-terra.nix;
              symengine = builtins.scopedImport {inherit super pkgs;} ./overrides/symengine.nix;
              rustworkx = builtins.scopedImport {inherit super pkgs;} ./overrides/rustworkx.nix;
              cryptography = builtins.scopedImport {inherit super pkgs;} ./overrides/cryptography.nix;

              # Simple additions
              pathspec = extraBuildInputs super.pathspec [super.flit-core];
              nevergrad = extraBuildInputs super.nevergrad [super.setuptools];
              optuna = extraBuildInputs super.optuna [super.setuptools];
              cotengra = extraBuildInputs super.cotengra [super.setuptools];
              matplotlib = extraBuildInputs super.matplotlib [super.pybind11];
              iniconfig = extraBuildInputs super.iniconfig [super.hatchling super.hatch-vcs];
              filelock = extraBuildInputs super.filelock [super.setuptools super.hatchling super.hatch-vcs];
              cmaes = extraBuildInputs super.cmaes [super.setuptools];
              virtualenv = extraBuildInputs super.virtualenv [super.hatchling super.hatch-vcs];
              cvxopt = extraBuildInputs super.cvxopt [super.setuptools pkgs.lapack-reference pkgs.suitesparse];
              autoray = extraBuildInputs super.autoray [super.setuptools];

              # Several overrides
              tweedledum =
                super.tweedledum.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or []) ++ [super.scikit-build];
                    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
                    dontUseCmakeConfigure = true;
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
            });
        };
    });
}
