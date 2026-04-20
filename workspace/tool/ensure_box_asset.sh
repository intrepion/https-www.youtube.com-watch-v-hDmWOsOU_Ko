#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_dir="$(cd "$script_dir/.." && pwd)"
asset_path="$workspace_dir/assets/box0001.png"

if [ -f "$asset_path" ]; then
  exit 0
fi

mkdir -p "$(dirname "$asset_path")"

base64_png='iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aF9sAAAAASUVORK5CYII='

if base64 --help 2>&1 | grep -q -- '-d'; then
  printf '%s' "$base64_png" | base64 -d > "$asset_path"
else
  printf '%s' "$base64_png" | base64 -D > "$asset_path"
fi

echo "Created fallback asset at $asset_path"
