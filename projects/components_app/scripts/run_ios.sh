#!/bin/sh
# Run setup_env.sh so API_KEY from .env is in Env.xcconfig, then start the app.
# Use this so iOS builds see your current .env (e.g. after changing API_KEY).
set -e
cd "$(dirname "$0")/.."
PROJECT_DIR="$(pwd)/ios" /bin/sh ios/setup_env.sh
exec flutter run ios "$@"
