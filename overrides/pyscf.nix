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
)
