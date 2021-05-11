#!/usr/bin/env bash

declare -a errors

[ -n "${PKENV_DEBUG}" ] && set -x
# shellcheck source=./test/helpers
source "$(dirname "$0")/helpers" ||
  error_and_die "Failed to load test helpers: $(dirname "$0")/helpers"

PKENV_BIN_DIR=/tmp/pkenv-test
rm -rf ${PKENV_BIN_DIR} && mkdir ${PKENV_BIN_DIR}
ln -s "${PWD}/bin/pkenv" "${PKENV_BIN_DIR}"
ln -s "${PWD}/bin/packer" "${PKENV_BIN_DIR}"
export PATH="${PKENV_BIN_DIR}:${PATH}"

echo "### Test supporting symlink"
v="1.3.3"
cleanup || error_and_die "Cleanup failed?!"
pkenv install "${v}" || error_and_proceed "Install failed"
check_version "${v}" || error_and_proceed "Version check failed"

if [ ${#errors[@]} -gt 0 ]; then
  echo -e '\033[0;31m===== The following symlink tests failed =====\033[0;39m' >&2
  for error in "${errors[@]}"; do
    echo -e "\\t${error}"
  done
  exit 1
else
  echo -e '\033[0;32mAll symlink tests passed.\033[0;39m'
fi
exit 0
