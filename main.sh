#!/usr/bin/env bash

declare -A packages_arr=(
  [git]=./git.sh
  [nodejs]=./nodejs.sh
  [vscode]=./vscode.sh
)

sudo apt update
# Shared prerequisites needed by multiple packages
SHARED_PREREQS=("curl" "gnupg")

confirmation_prompt() {
  local ANSWER
  local PACKAGE=$1

  read -p " Do you want to install ${PACKAGE} : (y/n) " ANSWER

  if [[ ${ANSWER,,} == 'y' ]]; then
    echo "Continuing with ${PACKAGE} installation ..................."
    return 0
  else
    return 1
  fi
}

# Centralized prerequisite installation
install_shared_prerequisites() {
  local MISSING=()

  echo "Checking for shared prerequisites: ${SHARED_PREREQS[*]}"

  # Check each prerequisite
  for prereq in "${SHARED_PREREQS[@]}"; do
    if ! command -v "$prereq" &>/dev/null; then
      # Special case: gnupq provides 'gpg' command
      if [[ "$prereq" == "gnupg" ]] && command -v gpg &>/dev/null; then
        continue
      fi
      MISSING+=("$prereq")
    fi
  done

  # Install missing prerequisites
  if [[ ${#MISSING[@]} -gt 0 ]]; then
    echo "Missing prerequisites: ${MISSING[*]}"
    echo "Attempting to install..."

    # Update once, install all missing
    apt update
    apt install "${MISSING[@]}" -y

    if [[ $? -ne 0 ]]; then
      echo "ERROR: Failed to install prerequisites"
      exit 1
    fi
    echo "Prerequisites installed successfully"
  else
    echo "All shared prerequisites found"
  fi
}

# Main execution
echo "=== Debian Web Development Setup ==="
echo ""

# Install shared prerequisites once at the beginning
install_shared_prerequisites

# Loop through packages
for package in "${!packages_arr[@]}"; do
  echo ""
  if confirmation_prompt "$package"; then
    if [[ -f "${packages_arr[$package]}" ]]; then
      "./${packages_arr[$package]}"
    else
      echo "ERROR: Installation script for ${package} not found!"
    fi
  else
    echo "Skipped ${package} installation"
  fi
done

echo ""
echo "=== Setup Complete ==="
