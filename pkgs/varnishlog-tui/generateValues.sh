#!/usr/bin/env bash
set -eu -o pipefail

[[ -n "${1-}" ]] || {
    echo "Give a tag as first parameter, i.e. v0.2.1"
    exit 1
}
tag="$1"

REPO_API="https://api.github.com/repos/aorith/varnishlog-tui/releases/latest"
TMP_DIR=$(mktemp -d)
declare -A shaMap
declare -A urlMap

release_data=$(curl -s "$REPO_API")
release_tarballs="$(jq -e -r --arg tag "$tag" '. | select (.tag_name == $tag) | .assets[] | select(.name | endswith(".tar.gz")) | .browser_download_url' <<<"$release_data")"

for url in $release_tarballs; do
    filename=$(basename "$url")
    sha=$(nix-prefetch-url "$url")

    case $filename in
    *Linux_x86_64*.tar.gz)
        shaMap["x86_64-linux"]="$sha"
        urlMap["x86_64-linux"]="$url"
        ;;
    *Linux_arm64*.tar.gz)
        shaMap["aarch64-linux"]="$sha"
        urlMap["aarch64-linux"]="$url"
        ;;
    *Darwin_x86_64*.tar.gz)
        shaMap["x86_64-darwin"]="$sha"
        urlMap["x86_64-darwin"]="$url"
        ;;
    *Darwin_arm64*.tar.gz)
        shaMap["aarch64-darwin"]="$sha"
        urlMap["aarch64-darwin"]="$url"
        ;;
    esac
done

generateSha() {
    echo "shaMap = {"
    for platform in "${!shaMap[@]}"; do
        echo "  $platform = \"${shaMap[$platform]}\";"
    done
    echo "};"
}

generateSha >"$TMP_DIR/shaMap.nix"

generateURL() {
    echo "urlMap = {"
    for platform in "${!urlMap[@]}"; do
        echo "  $platform = \"${urlMap[$platform]}\";"
    done
    echo "};"
}

generateURL >"$TMP_DIR/urlMap.nix"

echo >values.nix
{
    echo "{"
    echo "version = \"${tag/v/}\";"
    cat "$TMP_DIR/shaMap.nix"
    cat "$TMP_DIR/urlMap.nix"
    echo "}"
} >>values.nix
nixfmt values.nix

rm -rf "$TMP_DIR"
