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
    cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
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
    buildInputs = (old.buildInputs or []) ++ [super.setuptools];
  }
)
