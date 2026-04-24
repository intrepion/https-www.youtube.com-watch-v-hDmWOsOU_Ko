#!/usr/bin/env bash
set -euo pipefail

line_minimum="${1:-90}"
branch_minimum="${2:-}"
lcov_file="${3:-coverage/lcov.info}"

if [[ ! -f "$lcov_file" ]]; then
  echo "Coverage file not found: $lcov_file" >&2
  exit 1
fi

line_coverage="$(
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

awk -v coverage="$line_coverage" -v minimum="$line_minimum" 'BEGIN { exit coverage + 0 >= minimum + 0 ? 0 : 1 }' || {
  echo "Line coverage ${line_coverage}% is below required ${line_minimum}%." >&2
  exit 1
}

echo "Line coverage ${line_coverage}% meets required ${line_minimum}%."

if [[ -n "$branch_minimum" ]]; then
  branch_coverage="$(
    awk -F: '
      /^BRDA:/ {
        split($2, branch, ",")
        total += 1
        if (branch[4] != "-" && branch[4] + 0 > 0) {
          hit += 1
        }
      }
      END {
        if (total == 0) {
          print "0.00"
        } else {
          printf "%.2f", hit / total * 100
        }
      }
    ' "$lcov_file"
  )"

  awk -v coverage="$branch_coverage" -v minimum="$branch_minimum" 'BEGIN { exit coverage + 0 >= minimum + 0 ? 0 : 1 }' || {
    echo "Branch coverage ${branch_coverage}% is below required ${branch_minimum}%." >&2
    exit 1
  }

  echo "Branch coverage ${branch_coverage}% meets required ${branch_minimum}%."
fi
