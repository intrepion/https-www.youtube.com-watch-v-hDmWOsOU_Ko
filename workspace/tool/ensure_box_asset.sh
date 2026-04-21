#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_dir="$(cd "$script_dir/.." && pwd)"
pubspec_path="$workspace_dir/pubspec.yaml"

if [ ! -f "$pubspec_path" ]; then
  echo "Missing pubspec.yaml at $pubspec_path" >&2
  exit 1
fi

base64_png='iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aF9sAAAAASUVORK5CYII='

decode_png() {
  if base64 --help 2>&1 | grep -q -- '-d'; then
    printf '%s' "$base64_png" | base64 -d
  else
    printf '%s' "$base64_png" | base64 -D
  fi
}

ensure_asset() {
  local relative_path="$1"
  local asset_path="$workspace_dir/$relative_path"

  if [ -f "$asset_path" ]; then
    return
  fi

  mkdir -p "$(dirname "$asset_path")"
  decode_png > "$asset_path"
  echo "Created fallback asset at $asset_path"
}

mapfile -t declared_assets < <(
  sed -n 's/^[[:space:]]*-[[:space:]]*\(assets\/[^[:space:]]*\.png\)[[:space:]]*$/\1/p' "$pubspec_path"
)

if [ "${#declared_assets[@]}" -eq 0 ]; then
  echo "No declared PNG assets found in $pubspec_path"
  exit 0
fi

for asset in "${declared_assets[@]}"; do
  ensure_asset "$asset"
done
