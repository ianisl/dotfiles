#!/usr/bin/env bash

# Settings
# ========
debug_md_processing=false

# Init
# ====
input_path="$1"
# Search for a template file. Note that we assume only one will be present
template_path=$(find "$(dirname "$input_path")" -name "pandoc-template.*")
# Search for bibliography-related files
bibliography_path=$(find "$(dirname "$input_path")" -name "*.bib")
csl_path=$(find "$(dirname "$input_path")" -name "*.csl")
# Get the desired output extension
output_extension="${template_path##*.}"
# Check if extension is supported
generate_action=""
template_option=""
case $output_extension in
    "docx")
        generate_action="generate_docx"
        template_option="--reference-doc"
        ;;
    "tex")
        # TODO
        echo "tex file"
        ;;
    *)
        # Unknown or empty extension
        echo "Error: no pandoc-template file found for any of the supported extensions"
        return
        ;;
esac

# Process markdown file
# =====================
# Load the input file
text=$(cat "$input_path")
# Remove comments
text=$(echo "$text" | sed -E 's/\[\]\([^()]*\)//g')
# Fix reference command hilight hack
text=$(echo "$text" | sed -E 's/\(\)//g')
# Remove custom title prefixes
text=$(echo "$text" | sed -E 's/^# —————— /# /g')
text=$(echo "$text" | sed -E 's/^##   ––– /## /g')
text=$(echo "$text" | sed -E 's/^###    – /### /g')
text=$(echo "$text" | sed -E 's/^####      • /#### /g')
# Remove text between ignore tags
# Source: https://stackoverflow.com/questions/6287755/using-sed-to-delete-all-lines-between-two-matching-patterns
text=$(echo "$text" | sed -E '/^<!-- begin ignore -->/,/^<!-- end ignore -->/{/^<!-- begin ignore -->/!{/^<!-- end ignore -->/!d;};}')

# Word document generation and preview
# ====================================
function generate_docx() {
    local output_path
    # ---------------------------------
    # Run Pandoc and get generated path
    # ---------------------------------
    output_path=$(run_pandoc)
    # -----------------------
    # Display the output file
    # -----------------------
    # Only if the pandoc command has succeeded
    if [ -n "$output_path" ]; then
        # Close the previously opened file. Note that if the Word document has been modified, a 'save or cancel' dialog will be raised and the following open command will not work
        osascript -e 'tell application "Microsoft Word"' -e 'activate' -e 'end tell' -e 'tell application "System Events" to keystroke "w" using command down'
        # Open the new file
        open "$output_path"
    fi
}

# Main Pandoc command
# ===================
function run_pandoc {
    local output_path
    # ------------------------
    # Generate the output file
    # ------------------------
    # Create a temp file (uses GNU mktemp)
    output_path="$(gmktemp --suffix=".$output_extension")"
    # Generate the output file into the generated temp file path and return this path if the pandoc command succeeds
    # Necessary to set IFS here as we can't enclose the $() commands into double quotes to deal with spaces: when the internal if condition is false, pandoc returns an error because it can't make sense of the empty "" in its path. We also need to use two $() to echo the option and its argument, otherwise the space between them messes things up.
    IFS="†"
    echo "$text" | pandoc -t "$output_extension" --wrap=preserve --parse-raw --filter pandoc-citeproc $(if [ -n "$bibliography_path" ]; then echo --bibliography; fi) $(if [ -n "$bibliography_path" ]; then echo "$bibliography_path"; fi) $(if [ -n "$csl_path" ]; then echo --csl; fi) $(if [ -n "$csl_path" ]; then echo "$csl_path"; fi) "$template_option" "$template_path" -o "$output_path" && echo "$output_path"
    unset IFS
}

# Run the main generate action
# ============================
if [ "$debug_md_processing" = true ]; then
    echo "$text"
elif [ -n "$generate_action" ]; then
    "$generate_action"
fi
