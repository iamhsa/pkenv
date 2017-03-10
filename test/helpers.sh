#!/usr/bin/env bash

check_version() {
  v=${1}
  [ -n "$(packer version | grep "Packer v${v}")" ]
}

cleanup() {
  rm -rf ./versions
  rm -rf ./.packer-version
}
