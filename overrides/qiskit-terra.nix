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
      ++ (with pkgs.rustPlatform; [
        rust.rustc
        rust.cargo
        cargoSetupHook
      ]);
  }
)
