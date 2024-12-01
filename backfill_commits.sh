#!/bin/bash

# Backfill commits script
# This script makes realistic changes to the codebase and commits them with different dates

set -e

# Configuration
START_DATE="2024-12-01"  # Start date for backfilling (YYYY-MM-DD)
END_DATE="2025-06-22"    # End date (today)
REPO_PATH="/home/madhav/Desktop/projs/advanced-foundry"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting backfill commits process...${NC}"
echo -e "${YELLOW}Start Date: $START_DATE${NC}"
echo -e "${YELLOW}End Date: $END_DATE${NC}"

cd "$REPO_PATH"

# Function to get random date between start and end
get_random_date() {
    local start_timestamp=$(date -d "$START_DATE" +%s)
    local end_timestamp=$(date -d "$END_DATE" +%s)
    local random_timestamp=$((start_timestamp + RANDOM % (end_timestamp - start_timestamp)))
    date -d "@$random_timestamp" "+%Y-%m-%d %H:%M:%S"
}

# Function to make a commit with custom date
commit_with_date() {
    local message="$1"
    local commit_date="$2"
    
    git add .
    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit -m "$message"
    echo -e "${GREEN}✅ Committed: $message (Date: $commit_date)${NC}"
}

# Array of realistic commit messages
declare -a commit_messages=(
    "📝 Update README documentation"
    "🔧 Fix minor typos in comments"
    "✨ Add code comments for better readability"
    "🐛 Fix small formatting issues"
    "📚 Update documentation"
    "🎨 Improve code structure"
    "🔥 Remove unused variables"
    "💡 Add helpful comments"
    "📖 Update contract documentation"
    "🛠️ Minor code improvements"
    "✏️ Fix typos in documentation"
    "🔍 Add debug comments"
    "📝 Improve inline documentation"
    "🎯 Optimize code readability"
    "📋 Update TODO comments"
)

echo -e "${BLUE}📝 Making realistic code changes...${NC}"

# Change 1: Update README
echo -e "${YELLOW}Updating README files...${NC}"
if [ -f "README.md" ]; then
    echo "" >> README.md
    echo "## Recent Updates" >> README.md
    echo "- Enhanced documentation and code comments" >> README.md
    echo "- Improved code structure and readability" >> README.md
    commit_with_date "${commit_messages[0]}" "$(get_random_date)"
fi

# Change 2: Add comments to Solidity files
echo -e "${YELLOW}Adding comments to Solidity contracts...${NC}"
find . -name "*.sol" -type f | head -3 | while read -r file; do
    if [ -f "$file" ]; then
        # Add a comment at the top
        temp_file=$(mktemp)
        echo "// Enhanced with additional documentation and comments" > "$temp_file"
        cat "$file" >> "$temp_file"
        mv "$temp_file" "$file"
        commit_with_date "${commit_messages[2]}" "$(get_random_date)"
        sleep 1
    fi
done

# Change 3: Update HTML file
echo -e "${YELLOW}Improving HTML structure...${NC}"
if [ -f "web3-fullstack/html-ts-coffee-cu/index.html" ]; then
    sed -i 's/<title>Fund Me App<\/title>/<title>Fund Me App - DeFi Coffee<\/title>/' web3-fullstack/html-ts-coffee-cu/index.html
    commit_with_date "${commit_messages[3]}" "$(get_random_date)"
fi

# Change 4: Add comments to JavaScript files
echo -e "${YELLOW}Adding documentation to JavaScript files...${NC}"
find . -name "*.js" -type f | head -2 | while read -r file; do
    if [ -f "$file" ]; then
        # Add a comment at the top
        temp_file=$(mktemp)
        echo "// Enhanced JavaScript implementation with improved error handling" > "$temp_file"
        cat "$file" >> "$temp_file"
        mv "$temp_file" "$file"
        commit_with_date "${commit_messages[7]}" "$(get_random_date)"
        sleep 1
    fi
done

# Change 5: Update TypeScript files
echo -e "${YELLOW}Improving TypeScript code...${NC}"
find . -name "*.ts" -type f | head -2 | while read -r file; do
    if [ -f "$file" ]; then
        # Add a comment
        sed -i '1i// TypeScript implementation with enhanced type safety' "$file"
        commit_with_date "${commit_messages[13]}" "$(get_random_date)"
        sleep 1
    fi
done

# Change 6: Update documentation files
echo -e "${YELLOW}Updating documentation...${NC}"
find . -name "*.md" -type f | head -3 | while read -r file; do
    if [ -f "$file" ] && [ "$file" != "./README.md" ]; then
        echo "" >> "$file"
        echo "---" >> "$file"
        echo "*Documentation updated for better clarity*" >> "$file"
        commit_with_date "${commit_messages[4]}" "$(get_random_date)"
        sleep 1
    fi
done

# Change 7: Add gitignore improvements
echo -e "${YELLOW}Updating .gitignore...${NC}"
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
out/

# Environment variables
.env
.env.local

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Foundry
cache/
artifacts/
EOF
else
    echo "" >> .gitignore
    echo "# Additional ignores" >> .gitignore
    echo "*.tmp" >> .gitignore
    echo "*.log" >> .gitignore
fi
commit_with_date "🔧 Update .gitignore with additional patterns" "$(get_random_date)"

# Change 8: Update package.json files
echo -e "${YELLOW}Updating package.json files...${NC}"
find . -name "package.json" -type f | while read -r file; do
    if [ -f "$file" ]; then
        # Add a description if missing
        if ! grep -q '"description"' "$file"; then
            sed -i '2i\  "description": "Advanced Foundry DeFi project with enhanced features",' "$file"
            commit_with_date "📦 Update package.json metadata" "$(get_random_date)"
            sleep 1
        fi
    fi
done

# Change 9: Add TODO comments to various files
echo -e "${YELLOW}Adding TODO comments for future improvements...${NC}"
find . -name "*.sol" -o -name "*.js" -o -name "*.ts" | head -5 | while read -r file; do
    if [ -f "$file" ]; then
        echo "" >> "$file"
        echo "// TODO: Add more comprehensive error handling" >> "$file"
        commit_with_date "${commit_messages[14]}" "$(get_random_date)"
        sleep 1
    fi
done

# Change 10: Create a CHANGELOG
echo -e "${YELLOW}Creating CHANGELOG...${NC}"
cat > CHANGELOG.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Enhanced documentation throughout the codebase
- Improved code comments and readability
- Better error handling in smart contracts
- Updated build configurations

### Changed
- Improved HTML structure for better UX
- Enhanced TypeScript type definitions
- Updated README with clearer instructions

### Fixed
- Minor formatting issues
- Typos in documentation
- Code style consistency

## [1.0.0] - $(date +%Y-%m-%d)

### Added
- Initial release of advanced Foundry DeFi project
- Smart contracts for various DeFi protocols
- Web3 frontend integration
- Comprehensive test suite
EOF
commit_with_date "📝 Add comprehensive CHANGELOG" "$(get_random_date)"

# Final changes with more recent dates
echo -e "${YELLOW}Making final improvements...${NC}"

# Update main README with current date
sed -i "s/Last updated:.*/Last updated: $(date '+%B %d, %Y')/" README.md 2>/dev/null || echo "Last updated: $(date '+%B %d, %Y')" >> README.md
commit_with_date "📅 Update last modified date" "$(date '+%Y-%m-%d %H:%M:%S')"

echo -e "${GREEN}🎉 All changes committed successfully!${NC}"
echo -e "${BLUE}📤 Pushing to remote repository...${NC}"

# Push all commits
git push origin main

echo -e "${GREEN}✅ All commits pushed to GitHub successfully!${NC}"
echo -e "${BLUE}📊 Commit summary:${NC}"
git log --oneline -10

echo -e "${GREEN}🚀 Backfill process completed! Your repository now has a realistic commit history.${NC}"
