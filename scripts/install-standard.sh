
#!/usr/bin/env bash
set -euo pipefail

#
# Install NixOS anywhere using a "standard-installer" config, without modifying your repo:
# - copies repo into /tmp
# - asks user to select target disk remotely
# - patches disko device in the /tmp copy
# - runs nixos-anywhere (SSH interactive, password prompt ok)
# - copies generated hardware-configuration.nix back into your real repo
#
# Usage:
#   ./scripts/install-anywhere-tmp.sh --target root@192.168.56.5:22
#
# Optional:
#   --ssh-options "..."    (extra ssh options for manual tweaking)
#

TARGET=""
EXTRA_SSH_OPTS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --ssh-options) EXTRA_SSH_OPTS="$2"; shift 2 ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${TARGET}" ]]; then
  echo "Missing --target. Example:" >&2
  echo "  ./scripts/install-anywhere-tmp.sh --target root@192.168.56.5:22" >&2
  exit 1
fi

# Parse user@host:port (port optional)
USER_PART="${TARGET%@*}"
HOSTPORT_PART="${TARGET#*@}"

PORT="22"
HOSTNAME="${HOSTPORT_PART}"

if [[ "${HOSTPORT_PART}" =~ ^(.+):([0-9]+)$ ]]; then
  HOSTNAME="${BASH_REMATCH[1]}"
  PORT="${BASH_REMATCH[2]}"
fi

DEST="${USER_PART}@${HOSTNAME}"

# SSH options (no known_hosts pollution, still interactive)
SSH_OPTS=(
  -p "${PORT}"
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
)

# Allow extra ssh options string (advanced)
if [[ -n "${EXTRA_SSH_OPTS}" ]]; then
  # shellcheck disable=SC2206
  SSH_OPTS+=(${EXTRA_SSH_OPTS})
fi

echo "[+] Testing SSH connectivity (password prompt expected)..."
ssh "${SSH_OPTS[@]}" "${DEST}" "echo 'SSH OK on target:' \$(hostname)"

echo
echo "[+] Detecting disks on target..."
REMOTE_DISKS="$(ssh "${SSH_OPTS[@]}" "${DEST}" \
  "lsblk -dpno NAME,SIZE,MODEL,TRAN,RM | egrep '/dev/(sd|nvme|vd|xvd)' || true")"

if [[ -z "${REMOTE_DISKS}" ]]; then
  echo "Could not detect disks via lsblk. Aborting." >&2
  exit 1
fi

echo "Disks detected (RM=1 means removable):"
echo "${REMOTE_DISKS}" | nl -w2 -s'. '

echo
read -r -p "Select disk number to INSTALL ON (WILL BE WIPED): " DISK_IDX

DISK_DEV="$(echo "${REMOTE_DISKS}" | sed -n "${DISK_IDX}p" | awk '{print $1}')"
if [[ -z "${DISK_DEV}" ]]; then
  echo "Invalid selection." >&2
  exit 1
fi

echo "[!] You selected: ${DISK_DEV}"
read -r -p "Type 'YES' to confirm disk wipe: " CONFIRM
if [[ "${CONFIRM}" != "YES" ]]; then
  echo "Aborted."
  exit 0
fi

# Find your real repo root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${REPO_ROOT}" ]]; then
  echo "Error: this script must be run inside your git repo." >&2
  exit 1
fi

# Create temp repo copy
TMP_REPO="$(mktemp -d -t mac-nixos-anywhere-XXXXXXXX)"
cleanup() {
  rm -rf "${TMP_REPO}"
}
trap cleanup EXIT

echo
echo "[+] Copying repo into: ${TMP_REPO}"
# Copy everything (including untracked) except .git to avoid weird flake behaviors
rsync -a --exclude '.git' "${REPO_ROOT}/" "${TMP_REPO}/"

# Paths inside temp repo
DISKO_FILE_TMP="${TMP_REPO}/hosts/standard/disko.nix"
HW_OUT_REAL="${REPO_ROOT}/hosts/standard/hardware-configuration.nix"
HW_OUT_TMP="${TMP_REPO}/hosts/standard/hardware-configuration.nix"

# Sanity
if [[ ! -f "${DISKO_FILE_TMP}" ]]; then
  echo "Error: ${DISKO_FILE_TMP} not found. Create hosts/standard/disko.nix first." >&2
  exit 1
fi

echo
echo "[+] Patching disko in /tmp copy: ${DISKO_FILE_TMP}"
echo "    device => ${DISK_DEV}"

# Replace any device = "....";
# (Works whether it's CHANGE_ME or something else)
perl -pi -e "s|device\\s*=\\s*\"[^\"]+\"\\s*;|device = \"${DISK_DEV}\";|g" "${DISKO_FILE_TMP}"

# Run nixos-anywhere using the /tmp copy flake
FLAKE_REF="${TMP_REPO}#standard-installer"

echo
echo "[+] Running nixos-anywhere..."
echo "    flake:  ${FLAKE_REF}"
echo "    target: ${DEST} (port ${PORT})"
echo "    hw out: ${HW_OUT_REAL}"
echo
echo "NOTE: disko will ask for LUKS passphrase interactively (normal)."
echo

# nixos-anywhere supports ssh options and ssh port (if needed)
# If you want to avoid SSH password prompts entirely, you can use SSHPASS + --env-password
# (optional; not used here because you asked for interactive prompts).
nixos-anywhere \
  --ssh-port "${PORT}" \
  --ssh-option StrictHostKeyChecking=no \
  --ssh-option UserKnownHostsFile=/dev/null \
  --generate-hardware-config nixos-generate-config "${HW_OUT_TMP}" \
  --flake "${FLAKE_REF}" \
  --target-host "${DEST}"

echo
echo "[+] Done."

