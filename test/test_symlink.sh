#!/usr/bin/env bash

[ -n "$PKENV_DEBUG" ] && set -x
source $(dirname $0)/helpers.sh

PKENV_BIN_DIR=/tmp/pkenv-test
rm -rf ${PKENV_BIN_DIR} && mkdir ${PKENV_BIN_DIR}
ln -s ${PWD}/bin/* ${PKENV_BIN_DIR}
export PATH="${PKENV_BIN_DIR}:${PATH}"

echo ""
echo "### Test supporting symlink"
cleanup
pkenv install 0.12.2
pkenv use 0.12.2
check_version 0.12.2
