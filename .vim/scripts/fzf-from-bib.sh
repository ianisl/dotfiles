#!/usr/bin/env bash

# Init
# ====
input_path="$1"
# Search for a bibtex file. Note that we assume only one will be present
bibliography_path=$(find "$(dirname "$input_path")" -name "*.bib")

# Build fzf output
# ================
# Adapted from: https://stackoverflow.com/a/45201229
bibliography_text=$(cat "$bibliography_path")
# Instead of a regexp or we use the t command to insert a newline after the title match (see: https://stackoverflow.com/a/13014199). For brackets, try to match with two pairs of brackets first, then a single one.
bibliography_text=$(echo "$bibliography_text" | sed -nE "s/^@\w+\{([^,]+),/\1/p; t; s/\s+title = \{\{(.+)\}\},/\1\n/p; t; s/\s+title = \{(.+)\},/\1\n/p")
bibliography_text=$(echo "$bibliography_text" | awk 'BEGIN{RS=""; FS="\n"; OFS=": "}{print $1,$2}')
# Displat text to be parsed by fzf
echo "$bibliography_text"
