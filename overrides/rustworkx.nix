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
      ++ (with pkgs.rustPlatform; [
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
)
