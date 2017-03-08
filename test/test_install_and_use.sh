#!/usr/bin/env bash

[ -n "$PKENV_DEBUG" ] && set -x
source $(dirname $0)/helpers.sh

echo "### Install latest version"
cleanup

v=$(pkenv list-remote | head -n 1)
pkenv install latest
pkenv use ${v}
if ! check_version ${v}; then
  echo "Installing latest version ${v}" 1>&2
  exit 1
fi

echo "### Install latest version with Regex"
cleanup

v=$(pkenv list-remote | grep 0.8 | head -n 1)
pkenv install latest:^0.8
pkenv use latest:^0.8
if ! check_version ${v}; then
  echo "Installing latest version ${v} with Regex" 1>&2
  exit 1
fi

echo "### Install specific version"
cleanup

v=0.12.2
pkenv install ${v}
pkenv use ${v}
if ! check_version ${v}; then
  echo "Installing specific version ${v} failed" 1>&2
  exit 1
fi

echo "### Install .packer-version"
cleanup

v=0.9.0
echo ${v} > ./.packer-version
pkenv install
if ! check_version ${v}; then
  echo "Installing .packer-version ${v}" 1>&2
  exit 1
fi

echo "### Install invalid version"
cleanup

v=9.9.9
expected_error_message="'${v}' doesn't exist in remote, please confirm version name."
if [ -z "$(pkenv install ${v} | grep "${expected_error_message}")" ]; then
  echo "Installing invalid version ${v}" 1>&2
  exit 1
fi
