#!/usr/bin/env bash
set -e
[ -n "$PKENV_DEBUG" ] && set -x

program="${0##*/}"
exec "$(dirname `which $0`)"/pkenv exec "$@"
