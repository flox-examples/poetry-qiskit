{
  inline = {

    packages.myproject = {
      poetry2nix,
      python3Packages,
      rustPlatform,
      pkgs,
    }: let

      override = self: super: let
        # Helper function
        extraBuildInputs = super: extras: super.overridePythonAttrs ( old: {
          buildInputs = (old.buildInputs or []) ++ extras;
        } );
      in {
        # Complex overrides
        ruff = builtins.scopedImport {inherit super pkgs;} ../../overrides/ruff.nix;
        pyscf = builtins.scopedImport {inherit super pkgs;} ../../overrides/pyscf.nix;
        qiskit-aer = builtins.scopedImport {inherit super pkgs;} ../../overrides/qiskit-aer.nix;
        qiskit-terra = builtins.scopedImport {inherit super pkgs;} ../../overrides/qiskit-terra.nix;
        symengine = builtins.scopedImport {inherit super pkgs;} ../../overrides/symengine.nix;
        rustworkx = builtins.scopedImport {inherit super pkgs;} ../../overrides/rustworkx.nix;
        cryptography = builtins.scopedImport {inherit super pkgs;} ../../overrides/cryptography.nix;

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
        tweedledum = super.tweedledum.overridePythonAttrs ( old: {
          buildInputs = (old.buildInputs or []) ++ [super.scikit-build];
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
          dontUseCmakeConfigure = true;
        } );
        qdldl = super.qdldl.overridePythonAttrs ( old: {
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.cmake pkgs.pkg-config];
          dontUseCmakeConfigure = true;
        } );
      };

      poetryArgs = {
        projectDir = ../..;
        overrides  = poetry2nix.overrides.withDefaults override;
      };

      drv = poetry2nix.mkPoetryEnv poetryArgs;
      inherit (poetry2nix.mkPoetryPackages poetryArgs) poetryPackages;

    in drv // {
      passthru = ( drv.passthru or {} ) // {
        inherit poetryArgs poetryPackages;
        poetryOverride = override;
        addedPackages  = let
          keeps = builtins.filter ( { pname, ... }: builtins.elem pname [
            "ruff"
            "pyscf"
            "qiskit-aer"
            "qiskit-terra"
            "symengine"
            "rustworkx"
            "cryptography"
            "pathspec"
            "nevergrad"
            "optuna"
            "cotengra"
            "matplotlib"
            "iniconfig"  # FIXME: can't make standalone dir
            "filelock"
            "cmaes"
            "virtualenv"
            "cvxopt"
            "autoray"
            "tweedledum"
            "qdldl"
          ] ) poetryPackages;
          proc = { pname, ... } @ value: { name = pname; inherit value; };
        in builtins.listToAttrs ( map proc keeps );
      };
    };
  };
}
