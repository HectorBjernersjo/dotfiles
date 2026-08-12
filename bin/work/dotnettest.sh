#!/bin/bash

# 1. Check if an argument was provided
if [ -z "$1" ]; then
  echo -e "\033[31mError: Please provide a test name or file name.\033[0m"
  echo "Usage: ./runtest.sh MainSideMenuHelperTests"
  exit 1
fi

SEARCH_TERM=$1
ROOT_DIR=$(pwd)

echo -e "\033[36m🔍 Searching for test file matching: '$SEARCH_TERM'...\033[0m"

# 2. Find the file
# We search for a .cs file with the name, excluding bin and obj directories
# We take the first result (head -n 1)
TEST_FILE=$(find . -type f -name "${SEARCH_TERM}.cs" -not -path "*/obj/*" -not -path "*/bin/*" | head -n 1)

# If exact match not found, try fuzzy match
if [ -z "$TEST_FILE" ]; then
    echo "   Exact match not found, trying partial match..."
    TEST_FILE=$(find . -type f -name "*${SEARCH_TERM}*.cs" -not -path "*/obj/*" -not -path "*/bin/*" | head -n 1)
fi

if [ -z "$TEST_FILE" ]; then
  echo -e "\033[31m❌ Could not find any file matching '$SEARCH_TERM'.\033[0m"
  exit 1
fi

echo -e "   Found file: \033[33m$TEST_FILE\033[0m"

# 3. Find the parent .csproj
# We loop, going up one directory at a time until we find a .csproj or hit the root
CURRENT_DIR=$(dirname "$TEST_FILE")
PROJECT_FILE=""

while [[ "$CURRENT_DIR" != "." && "$CURRENT_DIR" != "/" ]]; do
    # Check for any .csproj file in current directory
    COUNT=$(ls "$CURRENT_DIR"/*.csproj 2>/dev/null | wc -l)
    
    if [ "$COUNT" -gt 0 ]; then
        # Get the first csproj found
        PROJECT_FILE=$(ls "$CURRENT_DIR"/*.csproj | head -n 1)
        break
    fi
    
    # Go up one level
    CURRENT_DIR=$(dirname "$CURRENT_DIR")
done

if [ -z "$PROJECT_FILE" ]; then
  echo -e "\033[31m❌ Could not determine the Project (.csproj) for this file.\033[0m"
  exit 1
fi

echo -e "   Found project: \033[32m$PROJECT_FILE\033[0m"
echo "--------------------------------------------------"

# 4. Run the test
# We use 'FullyQualifiedName~' which is a 'contains' operator, allowing you to pass partial names
CMD="dotnet test \"$PROJECT_FILE\" --filter \"FullyQualifiedName~$SEARCH_TERM\""

echo -e "\033[36m🚀 Running: $CMD\033[0m"
eval $CMD
