#!/usr/bin/env bash

[ -n "$PKENV_DEBUG" ] && set -x
source $(dirname $0)/helpers.sh

echo ""
echo "### List local versions"
cleanup

for v in 0.8.6 0.9.0-rc2 0.9.0 0.12.2 0.12.3; do
  pkenv install ${v}
done

result=$(pkenv list)
expected="$(cat << EOS
0.12.3
0.12.2
0.9.0
0.9.0-rc2
0.8.6
EOS
)"
if [ "${expected}" != "${result}" ]; then
  echo "Expected: ${expected}, Got: ${result}" 1>&2
  exit 1
fi
