{
  inputs.flox-floxpkgs.url = "github:flox/floxpkgs";

  outputs = inputs: inputs.flox-floxpkgs.project inputs (_: {});
}
