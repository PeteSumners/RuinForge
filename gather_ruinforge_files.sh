#!/bin/bash

# Script to gather relevant RuinForge files for chat sharing
OUTPUT_FILE="ruinforge_files_summary.txt"

# Clear previous output
echo "RuinForge Files Summary - $(date)" > "$OUTPUT_FILE"
echo "===========================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# List project root files
echo "Root Files:" >> "$OUTPUT_FILE"
ls -l *.godot *.md LICENSE 2>/dev/null >> "$OUTPUT_FILE" || echo "  (None found)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Scenes directory
echo "Scenes (*.tscn):" >> "$OUTPUT_FILE"
if [ -d "scenes" ]; then
    find scenes -type f -name "*.tscn" | while read -r file; do
        echo "File: $file" >> "$OUTPUT_FILE"
        echo "Contents preview (first 5 lines):" >> "$OUTPUT_FILE"
        head -n 5 "$file" >> "$OUTPUT_FILE"
        echo "------------------------" >> "$OUTPUT_FILE"
    done
else
    echo "  (No scenes directory)" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Scripts directory
echo "Scripts (*.gd):" >> "$OUTPUT_FILE"
if [ -d "scripts" ]; then
    find scripts -type f -name "*.gd" | while read -r file; do
        echo "File: $file" >> "$OUTPUT_FILE"
        echo "Contents:" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        echo "------------------------" >> "$OUTPUT_FILE"
    done
else
    echo "  (No scripts directory)" >> "$OUTPUT_FILE"
fi

echo "Summary complete. Check $OUTPUT_FILE"
