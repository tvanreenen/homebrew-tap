#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 3 ]] || { echo "usage: $0 <package> <v-version> <output-file>" >&2; exit 1; }
case "$1" in
  frame | key | xkcdpass)
    echo "$1 publication has moved to tvr-works/homebrew-tap" >&2
    ;;
  *) echo "unsupported package: $1" >&2 ;;
esac
exit 1
