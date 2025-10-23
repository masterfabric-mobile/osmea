#!/bin/sh
set -e

# This script generates an xcconfig file with environment variables from a .env file.
# It should be run as a build phase in Xcode.

# The root of the Flutter project (one level up from the ios directory).
FLUTTER_ROOT="$PROJECT_DIR/.."

# The path to the .env file.
ENV_FILE="$FLUTTER_ROOT/.env"

# The path to the generated xcconfig file.
XCCONFIG_FILE="$PROJECT_DIR/Runner/Generated.xcconfig"

# Clear the file.
> "$XCCONFIG_FILE"

if [ -f "$ENV_FILE" ]; then
  echo "Reading .env file at $ENV_FILE"
  # Use grep to filter for lines with '=', and then process them.
  # This avoids issues with empty lines.
  grep '=' "$ENV_FILE" | while read -r line; do
    # Write to xcconfig file
    echo "$line" >> "$XCCONFIG_FILE"
  done
else
  echo "warning: .env file not found at $ENV_FILE. Skipping..."
fi
