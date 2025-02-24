#!/bin/bash

# Function to stop the server
stop_server() {
    # Try to get PID from PID file first
    if [ -f "/tmp/presentation-server.pid" ]; then
        local SAVED_PID=$(cat /tmp/presentation-server.pid)
        if [ ! -z "$SAVED_PID" ]; then
            echo "Stopping server from PID file (PID: $SAVED_PID)..."
            kill -TERM $SAVED_PID 2>/dev/null || true
            rm -f "/tmp/presentation-server.pid"
        fi
    fi

    # Also try to stop our known server PID
    if [ ! -z "$SERVER_PID" ]; then
        echo "Stopping known server process (PID: $SERVER_PID)..."
        kill -TERM $SERVER_PID 2>/dev/null || true
    fi

    # More thorough port check using netstat instead of lsof
    local PORT_PID=$(netstat -tlnp 2>/dev/null | grep ":8000" | awk '{print $7}' | cut -d'/' -f1)
    if [ ! -z "$PORT_PID" ]; then
        echo "Cleaning up process on port 8000 (PID: $PORT_PID)..."
        kill -TERM $PORT_PID 2>/dev/null || true
        sleep 1
        kill -9 $PORT_PID 2>/dev/null || true
    fi
    
    # Reset PID variable
    SERVER_PID=""
    
    # Brief pause to let system clean up
    sleep 2
}

# Cleanup on script exit
trap stop_server EXIT

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

        if [ ! -f "$pdf_file" ] || [ ! -s "$pdf_file" ]; then
            # Stop any existing server
            stop_server

            # Start the web server in the background and capture PID
            echo "Starting server for ${dir}..."
            npm start "${dir}" &
            SERVER_PID=$!
            echo $SERVER_PID > /tmp/presentation-server.pid

            # wait for the server to be ready AND stable
            echo "Waiting for server to start..."
            attempt=0
            max_attempts=30
            while ! nc -z localhost 8000 && [ $attempt -lt $max_attempts ]; do
                sleep 1
                attempt=$((attempt + 1))
            done

            if [ $attempt -eq $max_attempts ]; then
                echo "Server failed to start after ${max_attempts} seconds"
                stop_server
                exit 1
            fi

            # Verify server process is still running
            if ! kill -0 $SERVER_PID 2>/dev/null; then
                echo "Server process died unexpectedly"
                stop_server
                exit 1
            fi

            echo "Server is ready!"
            echo "Waiting 5 seconds for server to fully stabilize..."
            sleep 5

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

            # Stop the server after PDF generation
            stop_server
            
            # Check final result
            if [ ! -s "$pdf_file" ]; then
                echo "  - ERROR: Failed to generate non-empty PDF after 3 attempts"
                exit 1
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
