#!/usr/bin/env bash

# ----------------
# Run with Gradlew
# ----------------
# This script assumes all sources are placed in a src/ folder within the project directory. It will look up from the invocation file path to the parent src/ folder, then try to find a gradlew executable and run it.
dir="$(dirname "$1")"
dir="${dir%/src*}"
if [ -f "$dir/gradlew" ]; then
    cd "$dir"
    ./gradlew run 2>&1
fi
unset dir
