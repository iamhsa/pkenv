#!/usr/bin/env bash

check_version() {
  v="${1}"
  [ -n "$(packer version | grep -E "^Packer v${v}(-dev)?$")" ]
}

cleanup() {
  rm -rf ./versions
  rm -rf ./.packer-version
}
