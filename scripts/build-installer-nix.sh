#!/usr/bin/env bash

set -e

BUILDKITE_BUILD_NUMBER=$1

rm -rf dist || true

CLUSTERS="$(cat $(dirname $0)/../installer-clusters.cfg | xargs echo -n)"

echo '~~~ Pre-building node_modules with nix'
nix-build default.nix -A rawapp.deps -o node_modules.root -Q

for cluster in ${CLUSTERS}
do
  echo '~~~ Building '${cluster}' installer'
  nix-build release.nix -A ${cluster}.installer --argstr buildNr $BUILDKITE_BUILD_NUMBER
  if [ -n "${BUILDKITE_JOB_ID:-}" ]; then
    buildkite-agent artifact upload result/daedalus*.bin --job $BUILDKITE_JOB_ID
    nix-build -A daedalus.cfg ./default.nix
    for cf in launcher-config wallet-topology
    do cp result/etc/$cf.yaml  $cf-${cluster}.linux.yaml
       buildkite-agent artifact upload $cf-${cluster}.linux.yaml --job $BUILDKITE_JOB_ID
    done
  fi
done
