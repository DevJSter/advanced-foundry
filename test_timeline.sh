#!/bin/bash

# Test timeline commits script - Creates commits every 6 hours for a few days
# Makes simple README changes (add/remove spaces, minor text updates)

set -e

# Configuration - TEST RANGE
START_DATE="2023-09-01"
END_DATE="2023-09-03"  # Just 2 days for testing
REPO_PATH="/home/madhav/Desktop/projs/advanced-foundry"
INTERVAL_HOURS=6

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 TESTING: Creating timeline commits every $INTERVAL_HOURS hours...${NC}"
echo -e "${YELLOW}From: $START_DATE to $END_DATE${NC}"

cd "$REPO_PATH"

# Get README files that actually exist
README_FILES=()
for file in "./README.md" "./defi/README.md" "./ERC20-Token/README.md" "./nft-collection/README.md" "./defi_stablecoins/README.md" "./web3-fullstack/html-ts-coffee-cu/README.md"; do
    if [ -f "$file" ]; then
        README_FILES+=("$file")
    fi
done

echo -e "${BLUE}📋 Found ${#README_FILES[@]} README files${NC}"

# Function to convert date to timestamp
date_to_timestamp() {
    date -d "$1" +%s
}

# Function to timestamp to date
timestamp_to_date() {
    date -d "@$1" "+%Y-%m-%d %H:%M:%S"
}

# Calculate start and end timestamps
start_timestamp=$(date_to_timestamp "$START_DATE 00:00:00")
end_timestamp=$(date_to_timestamp "$END_DATE 23:59:59")
interval_seconds=$((INTERVAL_HOURS * 3600))

echo -e "${BLUE}📊 Test span: $(((end_timestamp - start_timestamp) / 86400)) days${NC}"
echo -e "${BLUE}📈 Expected commits: $(((end_timestamp - start_timestamp) / interval_seconds))${NC}"

# Commit messages
commit_messages=(
    "📝 Update README documentation"
    "✨ Improve README formatting"
    "🔧 Fix typos in README"
    "📚 Enhance project description"
    "💡 Add helpful README notes"
    "🎨 Improve README structure"
)

# Function to make a small change to a README file
make_readme_change() {
    local file="$1"
    local change_type=$((RANDOM % 3))
    
    case $change_type in
        0)
            # Add extra space after periods
            sed -i 's/\. /\.  /g' "$file" 2>/dev/null || true
            ;;
        1)
            # Remove extra spaces
            sed -i 's/  / /g' "$file" 2>/dev/null || true
            ;;
        2)
            # Add/remove empty line at end
            if [ $((RANDOM % 2)) -eq 0 ]; then
                echo "" >> "$file"
            else
                # Remove last line if it's empty
                if [ -s "$file" ] && [ "$(tail -1 "$file")" = "" ]; then
                    sed -i '$d' "$file" 2>/dev/null || true
                fi
            fi
            ;;
    esac
}

# Function to commit with specific timestamp
commit_with_timestamp() {
    local message="$1"
    local timestamp="$2"
    local formatted_date=$(timestamp_to_date "$timestamp")
    
    # Only commit if there are changes
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        GIT_AUTHOR_DATE="$formatted_date" GIT_COMMITTER_DATE="$formatted_date" git commit -m "$message"
        echo -e "${GREEN}✅ $formatted_date: $message${NC}"
        return 0
    else
        echo -e "${YELLOW}⏭️  $formatted_date: No changes${NC}"
        return 1
    fi
}

current_timestamp=$start_timestamp
commit_count=0

while [ $current_timestamp -le $end_timestamp ]; do
    if [ ${#README_FILES[@]} -gt 0 ]; then
        # Pick a random README file
        readme_file="${README_FILES[$((RANDOM % ${#README_FILES[@]}))]}"
        
        # Make a small change
        make_readme_change "$readme_file"
        
        # Pick a random commit message
        message="${commit_messages[$((RANDOM % ${#commit_messages[@]}))]}"
        
        # Try to commit
        if commit_with_timestamp "$message" "$current_timestamp"; then
            commit_count=$((commit_count + 1))
        fi
    fi
    
    # Move to next time slot (6 hours later)
    current_timestamp=$((current_timestamp + interval_seconds))
done

echo -e "${GREEN}🎉 TEST Complete! Created $commit_count commits${NC}"
echo -e "${BLUE}📊 Recent commits:${NC}"
git log --format="%cd %s" --date=short -10
