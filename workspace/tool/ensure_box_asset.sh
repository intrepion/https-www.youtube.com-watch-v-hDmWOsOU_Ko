#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_dir="$(cd "$script_dir/.." && pwd)"
pubspec_path="$workspace_dir/pubspec.yaml"

if [ ! -f "$pubspec_path" ]; then
  echo "Missing pubspec.yaml at $pubspec_path" >&2
  exit 1
fi

base64_placeholder_png='iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAAAAAAAAQCEeRdzAAAADElEQVR4nGP4//8/AAX+Av4N70a4AAAAAElFTkSuQmCC'
base64_placeholder_webp='UklGRiQAAABXRUJQVlA4IBgAAAAwAQCdASoBAAEAAgA0JaQAA3AA/vuUAAA='
base64_placeholder_jpg='/9j//gAQTGF2YzYxLjE5LjEwMQD/2wBDAAgEBAQEBAUFBQUFBQYGBgYGBgYGBgYGBgYHBwcICAgHBwcGBgcHCAgICAkJCQgICAgJCQoKCgwMCwsODg4RERT/xABLAAEBAAAAAAAAAAAAAAAAAAAABwEBAAAAAAAAAAAAAAAAAAAAABABAAAAAAAAAAAAAAAAAAAAABEBAAAAAAAAAAAAAAAAAAAAAP/AABEIAAEAAQMBEgACEgADEgD/2gAMAwEAAhEDEQA/AL+AD//Z'
base64_placeholder_avif='AAAAIGZ0eXBhdmlmAAAAAGF2aWZtaWYxbWlhZk1BMUEAAADrbWV0YQAAAAAAAAAhaGRscgAAAAAAAAAAcGljdAAAAAAAAAAAAAAAAAAAAAAOcGl0bQAAAAAAAQAAAB5pbG9jAAAAAEQAAAEAAQAAAAEAAAETAAAAFgAAAChpaW5mAAAAAAABAAAAGmluZmUCAAAAAAEAAGF2MDFDb2xvcgAAAABqaXBycAAAAEtpcGNvAAAAFGlzcGUAAAAAAAAAAQAAAAEAAAAQcGl4aQAAAAADCAgIAAAADGF2MUOBIAAAAAAAE2NvbHJuY2x4AAEADQAGgAAAABdpcG1hAAAAAAAAAAEAAQQBAoMEAAAAHm1kYXQSAAoEOAAGCTIMFkAGGGGEAAB5S6xK'

decode_base64_image() {
  local base64_value="$1"

  if base64 --help 2>&1 | grep -q -- '-d'; then
    printf '%s' "$base64_value" | base64 -d
  else
    printf '%s' "$base64_value" | base64 -D
  fi
}

placeholder_base64_for_extension() {
  local extension="$1"

  case "$extension" in
    png)
      printf '%s' "$base64_placeholder_png"
      ;;
    webp)
      printf '%s' "$base64_placeholder_webp"
      ;;
    jpg|jpeg)
      printf '%s' "$base64_placeholder_jpg"
      ;;
    avif)
      printf '%s' "$base64_placeholder_avif"
      ;;
    *)
      echo "Unsupported image extension: $extension" >&2
      return 1
      ;;
  esac
}

ensure_asset() {
  local relative_path="$1"
  local asset_path="$workspace_dir/$relative_path"
  local extension="${relative_path##*.}"

  if [ -f "$asset_path" ]; then
    return
  fi

  mkdir -p "$(dirname "$asset_path")"
  decode_base64_image "$(placeholder_base64_for_extension "$extension")" > "$asset_path"
  echo "Created fallback asset at $asset_path"
}

mapfile -t declared_assets < <(
  sed -En 's/^[[:space:]]*-[[:space:]]*(assets\/[^[:space:]]*\.(png|webp|jpg|jpeg|avif))[[:space:]]*$/\1/p' "$pubspec_path"
)

if [ "${#declared_assets[@]}" -eq 0 ]; then
  echo "No declared image assets found in $pubspec_path"
  exit 0
fi

for asset in "${declared_assets[@]}"; do
  ensure_asset "$asset"
done
