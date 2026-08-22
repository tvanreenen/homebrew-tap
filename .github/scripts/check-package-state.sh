#!/usr/bin/env bash

set -euo pipefail

fail() {
  echo "$1" >&2
  exit 1
}

if [[ $# -ne 6 ]]
then
  fail "usage: $0 <formula|cask> <brew-ref> <version> <url> <sha256> <output-file>"
fi

kind="$1"
brew_ref="$2"
expected_version="$3"
expected_url="$4"
expected_sha256="$5"
output_file="$6"

[[ "${kind}" == "formula" || "${kind}" == "cask" ]] || fail "invalid package kind: ${kind}"
[[ "${output_file}" == /* ]] || fail "output file must be an absolute path"
[[ "${expected_sha256}" =~ ^[0-9a-f]{64}$ ]] || fail "invalid expected SHA-256"

command -v brew >/dev/null 2>&1 || fail "Homebrew is required"
command -v jq >/dev/null 2>&1 || fail "jq is required"

package_json="$(brew info --json=v2 "${brew_ref}")"
if [[ "${kind}" == "formula" ]]
then
  package_count="$(jq '.formulae | length' <<<"${package_json}")"
  [[ "${package_count}" == "1" ]] || fail "expected one formula for ${brew_ref}"
  current_version="$(jq -er '.formulae[0].versions.stable' <<<"${package_json}")"
  current_url="$(jq -er '.formulae[0].urls.stable.url' <<<"${package_json}")"
  current_sha256="$(jq -er '.formulae[0].urls.stable.checksum' <<<"${package_json}")"
else
  package_count="$(jq '.casks | length' <<<"${package_json}")"
  [[ "${package_count}" == "1" ]] || fail "expected one cask for ${brew_ref}"
  current_version="$(jq -er '.casks[0].version' <<<"${package_json}")"
  current_url="$(jq -er '.casks[0].url' <<<"${package_json}")"
  current_sha256="$(jq -er '.casks[0].sha256' <<<"${package_json}")"
fi

if [[ "${current_version}" == "${expected_version}" ]]
then
  if [[ "${current_url}" != "${expected_url}" || "${current_sha256}" != "${expected_sha256}" ]]
  then
    fail "${brew_ref} already names ${expected_version} with an inconsistent URL or checksum"
  fi
  echo "current=true" >>"${output_file}"
  exit 0
fi

comparison="$(
  brew ruby -e '
    require "version"
    current = ARGV.fetch(0).delete_prefix("v")
    requested = ARGV.fetch(1).delete_prefix("v")
    puts Version.new(current) <=> Version.new(requested)
  ' "${current_version}" "${expected_version}"
)"
[[ "${comparison}" =~ ^-?[01]$ ]] || fail "could not compare package versions"
if [[ "${comparison}" -ge 0 ]]
then
  fail "refusing to regress ${brew_ref} from ${current_version} to ${expected_version}"
fi

echo "current=false" >>"${output_file}"
