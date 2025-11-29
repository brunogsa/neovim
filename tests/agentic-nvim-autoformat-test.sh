#!/bin/bash

# Comprehensive test script for Neovim auto-indentation
# Tests Markdown, XML, and all Mermaid diagram types (flowchart, sequenceDiagram, stateDiagram)
# Usage: ./agentic-nvim-autoformat-test.sh [filename]
#        If no filename provided, runs full test suite

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to format a single file
format_file() {
  local file=$1
  echo "Formatting: $file"
  nvim --headless +"normal! gg=G" +wq "$file" 2>&1 | grep -E "lines indented" || true
}

# Function to test indentation and show result
test_indent() {
  local file=$1
  local description=$2

  echo -e "${BLUE}========================================${NC}"
  echo -e "${YELLOW}Testing: $description${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo "  File: $file"

  # Backup original
  cp "$file" "${file}.backup"

  # Run formatting
  format_file "$file"

  # Show result
  echo ""
  echo "  Result:"
  cat "$file" | sed 's/^/    /'
  echo ""

  # Restore backup
  mv "${file}.backup" "$file"
}

# Single file mode
if [ $# -eq 1 ]; then
  filename="$1"

  if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist"
    exit 1
  fi

  format_file "$filename"
  echo "Done formatting: $filename"
  exit 0
fi

# Full test suite mode
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Neovim Indentation Test Suite${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

test_passed=0

# Test 1: Markdown
if [ -f "test.md" ]; then
  test_indent "test.md" "Markdown with nested lists"
  test_passed=$((test_passed + 1))
fi

# Test 2: XML
if [ -f "test.xml" ]; then
  test_indent "test.xml" "XML with nested tags"
  test_passed=$((test_passed + 1))
fi

# Test 3: Basic Mermaid sequence diagram
if [ -f "test.mmd" ]; then
  test_indent "test.mmd" "Mermaid: Basic sequence diagram (alt/else/opt)"
  test_passed=$((test_passed + 1))
fi

# Test 4: Full Mermaid sequence diagram
if [ -f "test_sequence_full.mmd" ]; then
  test_indent "test_sequence_full.mmd" "Mermaid: All sequence diagram blocks (alt, opt, loop, par, critical, rect, break)"
  test_passed=$((test_passed + 1))
fi

# Test 5: Mermaid flowchart
if [ -f "test_flowchart.mmd" ]; then
  test_indent "test_flowchart.mmd" "Mermaid: Flowchart with nested subgraphs"
  test_passed=$((test_passed + 1))
fi

# Test 6: Mermaid state diagram
if [ -f "test_state.mmd" ]; then
  test_indent "test_state.mmd" "Mermaid: State diagram with composite states"
  test_passed=$((test_passed + 1))
fi

# Summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Test Summary${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Tests completed: $test_passed${NC}"
echo ""
echo -e "${GREEN}All tests completed!${NC}"
echo "Review the output above to verify indentation is correct."
echo ""
echo "Supported formats:"
echo "  - Markdown (.md): Nested lists with Treesitter"
echo "  - XML (.xml): Nested tags with Treesitter"
echo "  - Mermaid (.mmd): flowchart, sequenceDiagram, stateDiagram"
echo "    - Sequence: alt, else, opt, loop, par, and, critical, option, rect, break"
echo "    - Flowchart: subgraph (with nesting)"
echo "    - State: composite states with {}"