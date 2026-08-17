#!/usr/bin/env bash
# Fresh-machine entrypoint. Installs git + ansible, gets the repo, then runs the
# playbook for the detected profile. Safe to re-run.
#
#   Usage:  ./bootstrap.sh [wsl|desktop] [-- extra ansible-playbook args]
#   Examples:
#     ./bootstrap.sh                 # auto-detect profile
#     ./bootstrap.sh desktop         # force desktop profile
#     ./bootstrap.sh wsl -- --tags dotfiles   # fast partial rerun
set -euo pipefail

REPO="$HOME/dotfiles"
REPO_URL="https://github.com/HectorBjernersjo/dotfiles"

# --- args ------------------------------------------------------------------
PROFILE=""
EXTRA_ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    wsl|desktop) PROFILE="$1"; shift ;;
    --) shift; EXTRA_ARGS=("$@"); break ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

# --- detect distro ---------------------------------------------------------
# shellcheck disable=SC1091
. /etc/os-release
DISTRO_ID="${ID:-unknown}"

install_prereqs() {
  echo ">> Installing git + ansible via the system package manager..."
  case "$DISTRO_ID" in
    arch)
      sudo pacman -Sy --noconfirm --needed git ansible ;;
    debian|ubuntu|linuxmint|pop)
      sudo apt-get update && sudo apt-get install -y git ansible ;;
    fedora|rhel|centos)
      sudo dnf install -y git ansible ;;
    *)
      echo "Unsupported distro '$DISTRO_ID'. Install git + ansible manually, then re-run." >&2
      exit 1 ;;
  esac
}

command -v git >/dev/null 2>&1 && command -v ansible-playbook >/dev/null 2>&1 || install_prereqs

# --- get the repo ----------------------------------------------------------
# Plain git, not jj: jj isn't installed yet at this point. The toolchains role
# colocates this repo (`jj git init --colocate`) once jj is in place.
if [ ! -d "$REPO/.git" ]; then
  echo ">> Cloning dotfiles to $REPO..."
  git clone "$REPO_URL" "$REPO"
fi

# --- galaxy collections ----------------------------------------------------
echo ">> Installing required Ansible collections..."
ansible-galaxy collection install -r "$REPO/ansible/requirements.yml"

# --- pick profile ----------------------------------------------------------
if [ -z "$PROFILE" ]; then
  if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null || [ -n "${WSL_DISTRO_NAME:-}" ]; then
    PROFILE="wsl"
  else
    PROFILE="desktop"
  fi
fi
echo ">> Using profile: $PROFILE"

# --- run -------------------------------------------------------------------
cd "$REPO/ansible"
exec ansible-playbook -i "inventory/${PROFILE}.yml" site.yml --ask-become-pass "${EXTRA_ARGS[@]}"
