#!/bin/sh
# Run Components App on web. No asset config (app_config.json) required;
# MasterApp.runBefore uses fallback/defaults when config is missing.
set -e
cd "$(dirname "$0")/.."
exec flutter run -d chrome "$@"
