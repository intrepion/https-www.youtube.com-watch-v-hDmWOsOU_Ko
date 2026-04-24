set shell := ["bash", "-eu", "-c"]

default:
	@just --list

workspace := "workspace"

ensure-box-asset:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh)

ensure-declared-assets:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh)

restore:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter pub get)

format:
	(cd {{workspace}} && dart format lib test integration_test)

check-formatting:
	(cd {{workspace}} && dart format --output=none --set-exit-if-changed lib test integration_test)

check-tests:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter test)

coverage min="97" branch_min="97":
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter test --branch-coverage && bash tool/check_coverage.sh {{min}} {{branch_min}})

check-integration-tests:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter drive --driver=test_driver/integration_test.dart --target=integration_test/prism_editor_flow_test.dart -d chrome)

devices:
	(cd {{workspace}} && flutter devices)

emulators:
	(cd {{workspace}} && flutter emulators)

run:
	just run-web

run-web:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter run -d chrome --web-port 25616 < /dev/null)

run-ios device="":
	#!/usr/bin/env bash
	set -euo pipefail
	normalized_device='{{device}}'
	normalized_device="${normalized_device#\"}"
	normalized_device="${normalized_device%\"}"
	normalized_device="${normalized_device#device=}"
	if [ -n "$normalized_device" ]; then
	  (cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter run -d "$normalized_device")
	else
	  echo 'Use `just devices` and rerun with device="<ios-device-id-or-name>".' >&2
	  exit 1
	fi

run-android device="":
	#!/usr/bin/env bash
	set -euo pipefail
	normalized_device='{{device}}'
	normalized_device="${normalized_device#\"}"
	normalized_device="${normalized_device%\"}"
	normalized_device="${normalized_device#device=}"
	if [ -n "$normalized_device" ]; then
	  (cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter run -d "$normalized_device")
	else
	  echo 'Use `just devices` and rerun with device="<android-device-id-or-name>".' >&2
	  exit 1
	fi

run-macos:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter run -d macos)

run-windows:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter run -d windows)

run-linux:
	(cd {{workspace}} && ./tool/ensure_box_asset.sh && flutter run -d linux)

check-all:
	just check-formatting
	just check-tests
