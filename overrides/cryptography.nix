super.cryptography.overridePythonAttrs
(
  old: {
    cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
      inherit (old) src;
      name = "${old.pname}-${old.version}";
      sourceRoot = "${old.pname}-${old.version}/src/rust/";
      sha256 = "sha256-0x+KIqJznDEyIUqVuYfIESKmHBWfzirPeX2R/cWlngc=";
    };
    cargoRoot = "src/rust";
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ (with pkgs.rustPlatform; [
        rust.rustc
        rust.cargo
        cargoSetupHook
      ]);
  }
)
