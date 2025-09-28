#!/bin/bash

# Script to test autoformatting in neovim
# Usage: ./format_test.sh <filename>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename="$1"

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist"
    exit 1
fi

echo "Formatting file: $filename"
nvim --headless +"normal! gg=G" +wq "$filename"
echo "Done formatting: $filename"