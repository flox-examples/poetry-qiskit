#! /usr/bin/env bash
# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

set -eu;
set -o pipefail;

: "${NIX:=nix}";
: "${FLOX:=flox}";
: "${REALPATH:=$NIX shell nixpkgs#coreutils -c realpath}";

SPATH="$( $REALPATH "${BASH_SOURCE[0]}"; )";
SDIR="${SPATH%/*}";

: "${SYSTEM:=$( $NIX eval --raw --impure --expr builtins.currentSystem; )}";

declare -a pkgs;
if [[ "$*" = '--all' ]]; then
    pkgs=();
  for d in "$SDIR/pkgs/"*; do
    if [[ -d "$d" ]] && [[ "${d##*/}" != project ]]; then
      pkgs+=( "${d##*/}" );
    fi
  done
elif [[ "$#" -gt 0 ]]; then
  pkgs=( "$@" );
else
  echo "pub.sh: You must provide one or more package names" >&2;
  exit 1;
fi

for PKG in "${pkgs[@]}"; do
  if ! [[ -d "$SDIR/pkgs/$PKG" ]]; then
    echo "pub.sh: No such package: '$PKG'" >&2;
    exit 1;
  fi

  $FLOX                                                                  \
      --stability unstable                                               \
      publish                                                            \
      --attr "packages.$SYSTEM.$PKG"                                     \
      --build-repo 'git@github.com:flox-examples/poetry-qiskit.git'      \
      --publish-system "$SYSTEM"                                         \
      --channel-repo 'git@github.com:flox-examples/floxpkgs-python.git'  \
  ;
done


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
