#!/bin/bash

COMMIT_OLD=$1
COMMIT_NEW=$2

if [ -z "$COMMIT_OLD" ] || [ -z "$COMMIT_NEW" ]; then
  echo "Usage: $0 <old-commit-hash> <new-commit-hash>"
  exit 1
fi

echo "Files changed between $COMMIT_OLD and $COMMIT_NEW:"
CHANGED_FILES=$(git diff --name-only $COMMIT_OLD $COMMIT_NEW)

mkdir -p temp_diff_old temp_diff_new

for FILE in $CHANGED_FILES; do
  echo "Processing $FILE..."
  # Get content from old commit
  git show $COMMIT_OLD:"$FILE" > "temp_diff_old/$FILE" 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "  (File $FILE not found in $COMMIT_OLD - likely added in $COMMIT_NEW)"
    # Create an empty file for comparison if it was added
    touch "temp_diff_old/$FILE"
  fi

  # Get content from new commit
  git show $COMMIT_NEW:"$FILE" > "temp_diff_new/$FILE" 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "  (File $FILE not found in $COMMIT_NEW - likely deleted in $COMMIT_OLD)"
    # Create an empty file for comparison if it was deleted
    touch "temp_diff_new/$FILE"
  fi

  # You can now compare them, e.g., with 'diff' or a visual diff tool
  echo "  Comparison of $FILE (old vs new):"
  diff "temp_diff_old/$FILE" "temp_diff_new/$FILE"
  echo ""
done

echo "Temporary files are in temp_diff_old/ and temp_diff_new/."
echo "You can remove them with: rm -r temp_diff_old temp_diff_new"
