{ project, system, ... }: builtins.getAttr ( baseNameOf ./. ) ( (
  builtins.getAttr system project.inline.packages
).myproject.passthru.addedPackages )
