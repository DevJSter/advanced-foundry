#!/bin/bash

# Timeline commits script - Creates commits every 6 hours from start date to today
# Makes simple README changes (add/remove spaces, minor text updates)

set -e

# Configuration
START_DATE="2024-09-23"
END_DATE="2025-06-22"
REPO_PATH="/home/madhav/Desktop/projs/advanced-foundry"
INTERVAL_HOURS=6

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Creating timeline commits every $INTERVAL_HOURS hours...${NC}"
echo -e "${YELLOW}From: $START_DATE to $END_DATE${NC}"

cd "$REPO_PATH"

# Get all README files in the repo (excluding lib directories)
README_FILES=(
    "./README.md"
    "./defi/README.md" 
    "./ERC20-Token/README.md"
    "./nft-collection/README.md"
    "./defi_stablecoins/README.md"
    "./web3-fullstack/html-ts-coffee-cu/README.md"
)

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

echo -e "${BLUE}📊 Total time span: $(((end_timestamp - start_timestamp) / 86400)) days${NC}"
echo -e "${BLUE}📈 Estimated commits: $(((end_timestamp - start_timestamp) / interval_seconds))${NC}"

# Commit messages for different types of changes
commit_messages=(
    "📝 Update README documentation"
    "✨ Improve README formatting"
    "🔧 Fix typos in README"
    "📚 Enhance project description"
    "💡 Add helpful README notes"
    "🎨 Improve README structure"
    "📋 Update README sections"
    "🔍 Clarify README instructions"
    "📖 Refine documentation"
    "✏️ Polish README content"
    "🛠️ Update README details"
    "📝 Revise README information"
)

# Function to make a small change to a README file
make_readme_change() {
    local file="$1"
    local change_type=$((RANDOM % 4))
    
    if [ ! -f "$file" ]; then
        return 1
    fi
    
    case $change_type in
        0)
            # Add extra space somewhere
            sed -i 's/\./\. /g' "$file" 2>/dev/null || true
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
                sed -i '$d' "$file" 2>/dev/null || true
            fi
            ;;
        3)
            # Update "Last updated" or add timestamp
            if grep -q "Last updated" "$file"; then
                local current_date=$(date "+%B %d, %Y")
                sed -i "s/Last updated:.*/Last updated: $current_date/" "$file"
            else
                echo "" >> "$file"
                echo "Last updated: $(date "+%B %d, %Y")" >> "$file"
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
        echo -e "${YELLOW}⏭️  $formatted_date: No changes to commit${NC}"
        return 1
    fi
}

echo -e "${BLUE}🚀 Starting timeline generation...${NC}"

current_timestamp=$start_timestamp
commit_count=0
change_count=0

while [ $current_timestamp -le $end_timestamp ]; do
    # Pick a random README file that exists
    readme_file=""
    attempts=0
    while [ -z "$readme_file" ] && [ $attempts -lt 10 ]; do
        candidate="${README_FILES[$((RANDOM % ${#README_FILES[@]}))]}"
        if [ -f "$candidate" ]; then
            readme_file="$candidate"
        fi
        attempts=$((attempts + 1))
    done
    
    if [ -n "$readme_file" ]; then
        # Make a small change
        make_readme_change "$readme_file"
        change_count=$((change_count + 1))
        
        # Pick a random commit message
        message="${commit_messages[$((RANDOM % ${#commit_messages[@]}))]}"
        
        # Try to commit
        if commit_with_timestamp "$message" "$current_timestamp"; then
            commit_count=$((commit_count + 1))
        fi
        
        # Small delay to avoid too rapid commits
        sleep 0.1
    fi
    
    # Move to next time slot
    current_timestamp=$((current_timestamp + interval_seconds))
    
    # Progress indicator and periodic push every 50 commits
    if [ $((commit_count % 50)) -eq 0 ] && [ $commit_count -gt 0 ]; then
        echo -e "${BLUE}📊 Progress: $change_count changes made, $commit_count commits created${NC}"
        echo -e "${YELLOW}🔄 Pushing batch to remote...${NC}"
        if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
            echo -e "${GREEN}✅ Batch pushed successfully!${NC}"
        else
            echo -e "${YELLOW}⚠️  Push failed, will try again later${NC}"
        fi
    fi
done

echo -e "${GREEN}🎉 Timeline generation complete!${NC}"
echo -e "${BLUE}📊 Summary:${NC}"
echo -e "  • Changes made: $change_count"
echo -e "  • Commits created: $commit_count"
echo -e "  • Time span: $START_DATE to $END_DATE"

echo -e "${BLUE}📤 Pushing to remote repository...${NC}"

# Push to remote
if git remote get-url origin >/dev/null 2>&1; then
    if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
        echo -e "${GREEN}✅ All commits pushed successfully!${NC}"
    else
        echo -e "${YELLOW}⚠️  Push failed. You may need to push manually.${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No remote configured. Skipping push.${NC}"
fi

echo -e "${GREEN}🚀 Your repository now has commits spread across the entire timeline!${NC}"
git log --oneline --graph -20
