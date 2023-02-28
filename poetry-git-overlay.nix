{ pkgs }:
self: super: {

  cotengra = super.cotengra.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/jcmgray/cotengra.git";
        rev = "1a746c6483f6fdabfcf83abd5a436d0ac42921eb";
        sha256 = "1nwa176yjpdz0vr57g10n4kgl8rl67ybiy2rcvs9wrh8pb620j77";
      };
    }
  );

  qdldl = super.qdldl.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/osqp/qdldl-python.git";
        rev = "8211ee6f2338232b7763596659fd69f6a7d1dcc4";
        sha256 = "1kjgbcrklr6m9wqdfmcijdgk69gy81q1fjjjav28c869cm1n23yw";
      };
    }
  );

}
