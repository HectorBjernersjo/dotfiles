git status | grep -E 'Flex.Net/' | sed -E 's/(modified|new file):\s*//' | awk '{print }' | sort | uniq
