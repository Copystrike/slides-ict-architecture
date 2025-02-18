#!/bin/bash

for dir in theorieles*; do
    if [ -d "$dir" ]; then
        lesson_num=$(echo "$dir" | grep -o '[0-9]\+')
        pdf_file="presentaties/theorieles ${lesson_num}.pdf"
        
        if [ ! -f "$pdf_file" ]; then
            echo "Generating presentation for theorieles ${lesson_num}..."
            node slideExport.js "theorieles ${lesson_num}"
        fi
    fi
done
