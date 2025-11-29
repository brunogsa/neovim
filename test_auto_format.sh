#!/bin/bash

# Test script for auto-indentation in Neovim
# Tests .md, .xml, and .mmd files

echo "=== Testing Auto-Indentation ==="
echo ""

# Test Markdown
echo "1. Testing Markdown (test.md)..."
nvim -c "normal! Go  - New item" -c "write" -c "quit" test.md
echo "   Added a new list item to test.md"

# Test XML
echo "2. Testing XML (test.xml)..."
nvim -c "normal! /host<CR>o<tag>value</tag>" -c "write" -c "quit" test.xml
echo "   Added a new tag to test.xml"

# Test Mermaid
echo "3. Testing Mermaid (test.mmd)..."
nvim -c "normal! /alt Success<CR>oAPI->>User: Processing" -c "write" -c "quit" test.mmd
echo "   Added a new line to test.mmd"

echo ""
echo "=== Testing Auto-Reload ==="
echo ""

# Test auto-reload by modifying file externally
echo "4. Testing auto-reload..."
echo "   This test requires manual verification:"
echo "   - Open test.md in Neovim: nvim test.md"
echo "   - In another terminal, run: echo '- Auto-reload test' >> test.md"
echo "   - Switch back to Neovim and wait 2-3 seconds"
echo "   - You should see notification: 'File reloaded: test.md'"

echo ""
echo "All automated tests completed!"
echo "Please verify the indentation in the test files:"
echo "  - nvim test.md"
echo "  - nvim test.xml"
echo "  - nvim test.mmd"
