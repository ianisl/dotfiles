#!/usr/bin/env bash

dir="$(dirname "$1")"
processing-java  --force --sketch="$dir" --output="$dir/build-tmp" --run
unset dir
