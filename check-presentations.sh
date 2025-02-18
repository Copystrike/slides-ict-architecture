#!/bin/bash

echo "=== Starting Presentation Check ==="
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# wait for the server to be ready
echo "Waiting for server to start..."
while ! nc -z localhost 8000; do
    sleep 1
done
echo "Server is ready!"

# Increase initial wait time to ensure server is fully initialized
echo "Waiting 15 seconds for server to fully start..."
sleep 15

echo -e "\nScanning for theory lessons..."
for dir in "theorieles"*; do
    echo "Checking directory: ${dir}"
    if [ -d "$dir" ]; then
        lesson_num=$(echo "$dir" | grep -o '[0-9]\+')
        pdf_file="presentaties/theorieles-${lesson_num}.pdf"
        
        echo "  - Lesson number: ${lesson_num}"
        echo "  - Looking for PDF: ${pdf_file}"

        if [ ! -f "$pdf_file" ] || [ ! -s "$pdf_file" ]; then
            echo "  - PDF not found or empty, generating presentation..."
            echo "  - Running: node slideExport.js \"${dir}\""
            
            # Try up to 3 times to generate the PDF
            for attempt in {1..3}; do
                echo "  - Attempt $attempt of 3"
                node slideExport.js "${dir}"
                
                if [ -f "$pdf_file" ] && [ -s "$pdf_file" ]; then
                    echo "  - PDF generated successfully"
                    break
                else
                    echo "  - PDF generation failed or file is empty"
                    if [ $attempt -lt 3 ]; then
                        echo "  - Waiting 10 seconds before retry..."
                        sleep 10
                    fi
                fi
            done
            
            # Check final result
            if [ ! -s "$pdf_file" ]; then
                echo "  - ERROR: Failed to generate non-empty PDF after 3 attempts"
            fi
        else
            echo "  - PDF already exists and is not empty"
        fi
    else
        echo "  - Not a directory, skipping"
    fi
done

echo -e "\n=== Presentation Check Complete ==="
echo "Final directory contents:"
ls -la presentaties
echo "pwd is: $(pwd)"
ls -la /app
echo "=== End of Presentation Check ==="