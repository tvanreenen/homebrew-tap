#!/usr/bin/env bash

set -euo pipefail

fail() {
  echo "$1" >&2
  exit 1
}

if [[ $# -ne 3 ]]
then
  fail "usage: $0 <package> <v-prefixed-version> <output-file>"
fi

package="$1"
version="$2"
output_file="$3"
api_header="X-GitHub-Api-Version: 2026-03-10"
semver='^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-((0|[1-9][0-9]*|[0-9]*[A-Za-z-][0-9A-Za-z-]*)(\.(0|[1-9][0-9]*|[0-9]*[A-Za-z-][0-9A-Za-z-]*))*))?(\+([0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?$'
[[ "${version}" =~ ${semver} ]] || fail "version must be a valid v-prefixed Semantic Version"
[[ "${output_file}" == /* ]] || fail "output file must be an absolute path"

command -v gh >/dev/null 2>&1 || fail "gh CLI is required"
command -v jq >/dev/null 2>&1 || fail "jq is required"
command -v shasum >/dev/null 2>&1 || fail "shasum is required"

version_without_build="${version%%+*}"
expected_prerelease=false
if [[ "${version_without_build}" == *-* ]]
then
  expected_prerelease=true
fi

case "${package}" in
  xkcdpass)
    repository="tvanreenen/xkcdpass"
    kind="formula"
    token="xkcdpass"
    tap_path="Formula/xkcdpass.rb"
    formula_version="${version#v}"
    target_asset="xkcdpass_${version}_darwin_arm64.tar.gz"
    checksummed_assets=(
      "${target_asset}"
      "xkcdpass_${version}_linux_amd64.tar.gz"
    )
    expected_assets=("checksums.txt" "${checksummed_assets[@]}")
    ;;
  key)
    repository="tvanreenen/key"
    kind="cask"
    formula_version="${version}"
    if [[ "${version}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
      token="key"
      target_asset="Key-${version}.zip"
    elif [[ "${version}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+-(alpha|beta|rc)\.[0-9]+$ ]]
    then
      token="key@${BASH_REMATCH[1]}"
      target_asset="Key-Preview-${version}.zip"
    else
      fail "key requires a stable version or a numbered alpha, beta, or rc version"
    fi
    tap_path="Casks/${token}.rb"
    checksummed_assets=("${target_asset}")
    expected_assets=("checksums.txt" "${target_asset}")
    ;;
  frame)
    repository="tvanreenen/frame"
    kind="cask"
    token="frame"
    tap_path="Casks/frame.rb"
    [[ "${version}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
      fail "frame's stable cask requires a stable v-prefixed Semantic Version"
    formula_version="${version#v}"
    target_asset="Frame-${version}.zip"
    checksummed_assets=("${target_asset}")
    expected_assets=("checksums.txt" "${target_asset}")
    ;;
  *)
    fail "unsupported package: ${package}"
    ;;
esac

download_url="https://github.com/${repository}/releases/download/${version}/${target_asset}"
release_dir="$(mktemp -d "${RUNNER_TEMP:-/tmp}/homebrew-package-release.XXXXXX")"
trap 'rm -rf "${release_dir}"' EXIT
release_json="${release_dir}/release.json"

gh api -H "${api_header}" "repos/${repository}/releases/tags/${version}" >"${release_json}"
jq -e --arg version "${version}" --argjson prerelease "${expected_prerelease}" '
  .tag_name == $version and
  .draft == false and
  .published_at != null and
  .prerelease == $prerelease
' "${release_json}" >/dev/null || fail "${repository} release ${version} is not published with the expected metadata"

actual_assets="$(jq -r '.assets[].name' "${release_json}" | LC_ALL=C sort)"
sorted_expected_assets="$(printf '%s\n' "${expected_assets[@]}" | LC_ALL=C sort)"
[[ "${actual_assets}" == "${sorted_expected_assets}" ]] ||
  fail "${repository} release ${version} does not contain exactly the expected assets"

for asset in "${expected_assets[@]}"
do
  expected_url="https://github.com/${repository}/releases/download/${version}/${asset}"
  jq -e --arg name "${asset}" --arg url "${expected_url}" '
    [.assets[] | select(
      .name == $name and
      .state == "uploaded" and
      .browser_download_url == $url and
      (.digest | test("^sha256:[0-9a-f]{64}$"))
    )] | length == 1
  ' "${release_json}" >/dev/null || fail "release asset identity is invalid: ${asset}"
done

gh release download "${version}" \
  --repo "${repository}" \
  --dir "${release_dir}" \
  --pattern checksums.txt \
  --pattern "${target_asset}"

downloaded_files="$(
  find "${release_dir}" -maxdepth 1 -type f ! -name release.json -exec basename {} \; | LC_ALL=C sort
)"
expected_files="$(printf '%s\n' checksums.txt "${target_asset}" | LC_ALL=C sort)"
[[ "${downloaded_files}" == "${expected_files}" ]] ||
  fail "download did not produce exactly checksums.txt and ${target_asset}"

actual_checksum_assets=()
target_count=0
target_checksum=""
while IFS= read -r checksum_line || [[ -n "${checksum_line}" ]]
do
  [[ "${checksum_line}" =~ ^([0-9a-f]{64})\ \ ([0-9A-Za-z._+-]+)$ ]] ||
    fail "checksums.txt contains a malformed entry"
  checksum="${BASH_REMATCH[1]}"
  filename="${BASH_REMATCH[2]}"
  actual_checksum_assets+=("${filename}")
  if [[ "${filename}" == "${target_asset}" ]]
  then
    ((target_count += 1))
    target_checksum="${checksum}"
  fi
done <"${release_dir}/checksums.txt"

sorted_actual_checksum_assets="$(printf '%s\n' "${actual_checksum_assets[@]}" | LC_ALL=C sort)"
sorted_expected_checksum_assets="$(printf '%s\n' "${checksummed_assets[@]}" | LC_ALL=C sort)"
[[ "${sorted_actual_checksum_assets}" == "${sorted_expected_checksum_assets}" ]] ||
  fail "checksums.txt does not cover exactly the expected archives"
[[ ${target_count} -eq 1 ]] || fail "checksums.txt must name ${target_asset} exactly once"

actual_checksum="$(shasum -a 256 "${release_dir}/${target_asset}" | awk '{print $1}')"
[[ "${actual_checksum}" == "${target_checksum}" ]] || fail "${target_asset} does not match checksums.txt"

for asset in checksums.txt "${target_asset}"
do
  downloaded_digest="sha256:$(shasum -a 256 "${release_dir}/${asset}" | awk '{print $1}')"
  api_digest="$(jq -er --arg name "${asset}" '.assets[] | select(.name == $name) | .digest' "${release_json}")"
  [[ "${downloaded_digest}" == "${api_digest}" ]] ||
    fail "downloaded ${asset} does not match its GitHub release digest"
done

case "${package}" in
  xkcdpass)
    archive_root="${target_asset%.tar.gz}"
    expected_entry="${archive_root}/xkcdpass"
    archive_entries="$(tar -tzf "${release_dir}/${target_asset}")"
    [[ "${archive_entries}" == "${expected_entry}" ]] ||
      fail "unexpected xkcdpass archive layout: ${archive_entries}"
    extract_dir="${release_dir}/extracted"
    mkdir "${extract_dir}"
    tar -C "${extract_dir}" -xzf "${release_dir}/${target_asset}"
    binary="${extract_dir}/${expected_entry}"
    [[ -f "${binary}" && ! -L "${binary}" && -x "${binary}" ]] ||
      fail "xkcdpass archive does not contain the expected executable"
    binary_description="$(file "${binary}")"
    [[ "${binary_description}" == *"Mach-O 64-bit"* && "${binary_description}" == *"arm64"* ]] ||
      fail "unexpected xkcdpass binary format: ${binary_description}"
    binary_version="$("${binary}" --version)"
    [[ "${binary_version}" == "${version}" ]] ||
      fail "xkcdpass binary version does not match ${version}"
    ;;
  key | frame)
    unzip -tq "${release_dir}/${target_asset}" >/dev/null || fail "${target_asset} is not a valid ZIP archive"
    ;;
  *)
    fail "unsupported package after release verification: ${package}"
    ;;
esac

{
  echo "kind=${kind}"
  echo "token=${token}"
  echo "tap_path=${tap_path}"
  echo "brew_ref=tvanreenen/tap/${token}"
  echo "formula_version=${formula_version}"
  echo "download_url=${download_url}"
  echo "sha256=${target_checksum}"
} >>"${output_file}"
