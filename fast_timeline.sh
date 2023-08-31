#!/bin/bash

# Fast timeline commits script - Creates commits every 6 hours from 2023-09-01 to today
# Makes simple README changes efficiently

set -e

# Configuration
START_DATE="2023-09-01"
END_DATE="2025-06-22"
REPO_PATH="/home/madhav/Desktop/projs/advanced-foundry"
INTERVAL_HOURS=6

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Creating timeline commits every $INTERVAL_HOURS hours...${NC}"

cd "$REPO_PATH"

# Handle submodule issues first
git submodule update --init --recursive >/dev/null 2>&1 || true
git add . >/dev/null 2>&1 || true
git commit -m "🔧 Update submodules" >/dev/null 2>&1 || true

# Get actual README files that exist
README_FILES=()
for file in "./README.md" "./defi/README.md" "./ERC20-Token/README.md" "./nft-collection/README.md" "./defi_stablecoins/README.md"; do
    if [ -f "$file" ]; then
        README_FILES+=("$file")
    fi
done

echo -e "${BLUE}📋 Found ${#README_FILES[@]} README files${NC}"

# Calculate timestamps
start_timestamp=$(date -d "$START_DATE 00:00:00" +%s)
end_timestamp=$(date -d "$END_DATE 23:59:59" +%s)
interval_seconds=$((INTERVAL_HOURS * 3600))
total_commits=$(((end_timestamp - start_timestamp) / interval_seconds))

echo -e "${BLUE}📊 Will create approximately $total_commits commits${NC}"

# Commit messages
messages=("📝 Update README" "✨ Improve docs" "🔧 Fix typos" "📚 Enhance description" "💡 Add notes" "🎨 Format README")

# Progress tracking
current_timestamp=$start_timestamp
commit_count=0
batch_size=50

while [ $current_timestamp -le $end_timestamp ]; do
    if [ ${#README_FILES[@]} -gt 0 ]; then
        # Pick random file and make change
        file="${README_FILES[$((RANDOM % ${#README_FILES[@]}))]}"
        
        # Make simple change
        case $((RANDOM % 4)) in
            0) sed -i 's/\. /\.  /g' "$file" 2>/dev/null || true ;;
            1) sed -i 's/  / /g' "$file" 2>/dev/null || true ;;
            2) echo "" >> "$file" ;;
            3) [ -s "$file" ] && sed -i '$d' "$file" 2>/dev/null || true ;;
        esac
        
        # Commit if changes exist
        if [ -n "$(git status --porcelain)" ]; then
            git add . >/dev/null 2>&1
            commit_date=$(date -d "@$current_timestamp" "+%Y-%m-%d %H:%M:%S")
            message="${messages[$((RANDOM % ${#messages[@]}))]}"
            
            GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit -m "$message" >/dev/null 2>&1
            commit_count=$((commit_count + 1))
            
            # Progress update
            if [ $((commit_count % batch_size)) -eq 0 ]; then
                echo -e "${GREEN}✅ Created $commit_count commits ($(date -d "@$current_timestamp" "+%Y-%m-%d"))${NC}"
            fi
        fi
    fi
    
    current_timestamp=$((current_timestamp + interval_seconds))
done

echo -e "${GREEN}🎉 Timeline complete! Created $commit_count commits${NC}"
echo -e "${BLUE}📤 Pushing to remote...${NC}"

# Push to remote
if git push origin main >/dev/null 2>&1 || git push origin master >/dev/null 2>&1; then
    echo -e "${GREEN}✅ All commits pushed successfully!${NC}"
else
    echo -e "${YELLOW}⚠️  Push failed. You may need to push manually later.${NC}"
fi

echo -e "${GREEN}🚀 Your repository now has commits spread from $START_DATE to $END_DATE!${NC}"
echo -e "${BLUE}📊 Recent commits:${NC}"
git log --format="%cd %s" --date=short -10
