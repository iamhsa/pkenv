#!/usr/bin/env bash

declare -a errors

[ -n "$PKENV_DEBUG" ] && set -x
# shellcheck source=./test/helpers
source "$(dirname "$0")/helpers" ||
  error_and_die "Failed to load test helpers: $(dirname "$0")/helpers"

echo "### Install latest version"
cleanup || error_and_die "Cleanup failed?!"

v=$(pkenv list-remote | head -n 1)
(
  pkenv install latest || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing latest version ${v}"

echo "### Install latest version with Regex"
cleanup || error_and_die "Cleanup failed?!"

v=$(pkenv list-remote | grep 0.12 | head -n 1)
(
  pkenv install latest:^0.12 || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing latest version ${v} with Regex"

echo "### Install specific version"
cleanup || error_and_die "Cleanup failed?!"

v=1.0.1
(
  pkenv install "${v}" || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing specific version ${v}"

echo "### Install specific .packer-version"
cleanup || error_and_die "Cleanup failed?!"

v=1.2.0
echo ${v} >./.packer-version
(
  pkenv install || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing .packer-version ${v}"

echo "### Install specific .packer-version in path with spaces"
cleanup || error_and_die "Cleanup failed?!"

v=1.4.0
wdir="project with spaces"
mkdir "${wdir}"
cd "${wdir}" || exit 1
echo ${v} >./.packer-version
(
  pkenv install || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing specific .packer-version ${v} in path with space"
cd .. && rm -rf "${wdir}"

echo "### Install latest:<regex> .packer-version"
cleanup || error_and_die "Cleanup failed?!"

v=$(pkenv list-remote | grep -e '^1.1' | head -n 1)
echo "latest:^1.1" >./.packer-version
(
  pkenv install || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing .packer-version ${v}"

echo "### Install with ${HOME}/.packer-version"
cleanup || error_and_die "Cleanup failed?!"

if [ -f "${HOME}/.packer-version" ]; then
  mv "${HOME}/.packer-version" "${HOME}/.packer-version.bup"
fi
v=$(pkenv list-remote | head -n 2 | tail -n 1)
echo "${v}" >"${HOME}/.packer-version"
(
  pkenv install || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Installing ${HOME}/.packer-version ${v}"

echo "### Install with parameter and use ~/.packer-version"
v=$(pkenv list-remote | head -n 1)
(
  pkenv install "${v}" || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Use $HOME/.packer-version ${v}"

echo "### Use with parameter and  ~/.packer-version"
v=$(pkenv list-remote | head -n 2 | tail -n 1)
(
  pkenv use "${v}" || exit 1
  check_version "${v}" || exit 1
) || error_and_proceed "Use $HOME/.packer-version ${v}"

rm "$HOME/.packer-version"
if [ -f "$HOME/.packer-version.bup" ]; then
  mv "$HOME/.packer-version.bup" "$HOME/.packer-version"
fi

echo "### Install invalid specific version"
cleanup || error_and_die "Cleanup failed?!"

v=9.9.9
expected_error_message="No versions matching '${v}' found in remote"
# shellcheck disable=SC2143
[ -z "$(pkenv install "${v}" 2>&1 | grep "${expected_error_message}")" ] &&
  error_and_proceed "Installing invalid version ${v}"

echo "### Install invalid latest:<regex> version"
cleanup || error_and_die "Cleanup failed?!"

v="latest:word"
expected_error_message="No versions matching '${v}' found in remote"
# shellcheck disable=SC2143
[ -z "$(pkenv install ${v} 2>&1 | grep "${expected_error_message}")" ] &&
  error_and_proceed "Installing invalid version ${v}"

if [ ${#errors[@]} -gt 0 ]; then
  echo -e '\033[0;31m===== The following install_and_use tests failed =====\033[0;39m' >&2
  for error in "${errors[@]}"; do
    echo -e "\\t${error}"
  done
  exit 1
else
  echo -e '\033[0;32mAll install_and_use tests passed.\033[0;39m'
fi
exit 0
