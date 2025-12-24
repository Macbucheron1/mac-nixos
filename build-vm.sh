#!/usr/bin/env bash
set -euo pipefail

# Helper to rebuild the vm config after deleting the previous qcow2 image.
repo_root="$(cd "$(dirname "$0")" && pwd)"
cd "$repo_root"

qcow="${repo_root}/vm.qcow2"
if [[ -f "${qcow}" ]]; then
  echo "Removing existing ${qcow}"
  rm -f "${qcow}"
fi

exec sudo nixos-rebuild build-vm --flake "${repo_root}#vm" "$@"
