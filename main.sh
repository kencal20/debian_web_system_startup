#!/usr/bin/env bash

declare -A packages_arr=(
  [git]=./git.sh
  [nodejs]=./nodejs.sh
  [vscode]=./vscode.sh
)

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

for package in "${!packages_arr[@]}"; do
  if confirmation_prompt "$package"; then
    source ${packages_arr[$package]}
  else
    echo skipped package
  fi
done
