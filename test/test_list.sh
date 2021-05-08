#!/usr/bin/env bash

declare -a errors

function error_and_proceed() {
  errors+=("${1}")
  echo -e "pkenv: ${0}: Test Failed: ${1}" >&2
}

function error_and_die() {
  echo -e "pkenv: ${0}: ${1}" >&2
  exit 1
}

[ -n "${PKENV_DEBUG}" ] && set -x
source $(dirname $0)/helpers.sh ||
  error_and_die "Failed to load test helpers: $(dirname $0)/helpers.sh"

echo "### List local versions"
cleanup || error_and_die "Cleanup failed?!"

for v in 0.12.3 1.0.1 1.4.1; do
  pkenv install ${v} || error_and_proceed "Install of version ${v} failed"
done

result=$(pkenv list)
expected="$(
  cat <<EOS
* 1.4.1 (set by $(pkenv version-file))
  1.0.1
  0.12.3
EOS
)"

if [ "${expected}" != "${result}" ]; then
  error_and_proceed "List mismatch.\nExpected:\n${expected}\nGot:\n${result}"
fi

if [ ${#errors[@]} -gt 0 ]; then
  echo -e "\033[0;31m===== The following list tests failed =====\033[0;39m" >&2
  for error in "${errors[@]}"; do
    echo -e "\t${error}"
  done
  exit 1
else
  echo -e "\033[0;32mAll list tests passed.\033[0;39m"
fi
exit 0
