#!/usr/bin/env bash

[ -n "${PKENV_DEBUG}" ] && set -x
source $(dirname $0)/helpers.sh

echo ""
echo "### Remove local versions"
cleanup

for v in 0.1.0; do
  pkenv install ${v}
done

pkenv uninstall 0.1.0

pkenv list | grep 0.1.0 && exit 1 || exit 0
