#!/usr/bin/env bash

declare -a errors

function error_and_proceed() {
  errors+=("${1}")
  echo -e "pkenv: Test Failed: ${1}" >&2
}

function error_and_die() {
  echo -e "pkenv: ${1}" >&2
  exit 1
}

[ -n "${PKENV_DEBUG}" ] && set -x
source $(dirname $0)/helpers.sh \
  || error_and_die "Failed to load test helpers: $(dirname $0)/helpers.sh"

PKENV_BIN_DIR=/tmp/pkenv-test
rm -rf ${PKENV_BIN_DIR} && mkdir ${PKENV_BIN_DIR}
ln -s ${PWD}/bin/* ${PKENV_BIN_DIR}
export PATH="${PKENV_BIN_DIR}:${PATH}"

echo "### Test supporting symlink"
cleanup || error_and_die "Cleanup failed?!"
pkenv install 0.8.2 || error_and_proceed "Install failed"
pkenv use 0.8.2 || error_and_proceed "Use failed"
check_version 0.8.2 || error_and_proceed "Version check failed"

if [ ${#errors[@]} -gt 0 ]; then
  echo -e "\033[0;31m===== The following symlink tests failed =====\033[0;39m" >&2
  for error in "${errors[@]}"; do
    echo -e "\t${error}"
  done
  exit 1
else
  echo -e "\033[0;32mAll symlink tests passed.\033[0;39m"
fi;
exit 0
