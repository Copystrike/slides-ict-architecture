#!/bin/bash
echo "=== Starting Presentation Check ==="
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

echo -e "\nScanning for theory lessons..."
for dir in "theorieles"*; do
    echo "Checking directory: ${dir}"
    if [ -d "$dir" ]; then
        lesson_num=$(echo "$dir" | grep -o '[0-9]\+')
        pdf_file="presentaties/theorieles-${lesson_num}.pdf"
        
        echo "  - Lesson number: ${lesson_num}"
        echo "  - Looking for PDF: ${pdf_file}"

        if [ ! -f "$pdf_file" ]; then
            echo "  - PDF not found, generating presentation..."
            echo "  - Running: node slideExport.js \"${dir}\""
            node slideExport.js "${dir}"
            echo "  - Generation complete for ${dir}"
        else
            echo "  - PDF already exists"
        fi
    else
        echo "  - Not a directory, skipping"
    fi
done

echo -e "\n=== Presentation Check Complete ==="
echo "Final directory contents:"
ls -la presentaties/
