#!/usr/bin/env bash
set -euo pipefail

minimum="${1:-90}"
lcov_file="${2:-coverage/lcov.info}"

if [[ ! -f "$lcov_file" ]]; then
  echo "Coverage file not found: $lcov_file" >&2
  exit 1
fi

coverage="$(
  awk -F: '
    /^LF:/ { total += $2 }
    /^LH:/ { hit += $2 }
    END {
      if (total == 0) {
        print "0.00"
      } else {
        printf "%.2f", hit / total * 100
      }
    }
  ' "$lcov_file"
)"

awk -v coverage="$coverage" -v minimum="$minimum" 'BEGIN { exit coverage + 0 >= minimum + 0 ? 0 : 1 }' || {
  echo "Coverage ${coverage}% is below required ${minimum}%." >&2
  exit 1
}

echo "Coverage ${coverage}% meets required ${minimum}%."
