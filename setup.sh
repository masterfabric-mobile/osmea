#!/bin/bash

# Setup script for osmea project
# Usage: ./setup.sh [--pub]
#   --pub: Only run flutter pub get (skip build_runner)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Spinner characters
SPINNER_CHARS="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"

# Function to display messages
function info {
    echo -e "${BLUE}ℹ${NC}  ${BOLD}$1${NC}"
}

function success_message {
    echo -e "${GREEN}✓${NC}  ${GREEN}$1${NC}"
}

function error_message {
    echo -e "${RED}✗${NC}  ${RED}$1${NC}"
}

function warning_message {
    echo -e "${YELLOW}⚠${NC}  ${YELLOW}$1${NC}"
}

# Animated spinner function
function spinner() {
    local pid=$1
    local message=$2
    local delay=0.1
    local spinstr="${SPINNER_CHARS}"
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${CYAN}${spinstr:0:1}${NC}  ${message}"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r"
}

# Function to run command with spinner
function run_with_spinner() {
    local cmd=$1
    local message=$2
    local log_file=$(mktemp)
    
    ($cmd > "$log_file" 2>&1) &
    local pid=$!
    spinner $pid "$message"
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r${GREEN}✓${NC}  ${message} ${GREEN}✓${NC}\n"
    else
        printf "\r${RED}✗${NC}  ${message} ${RED}✗${NC}\n"
        cat "$log_file"
    fi
    
    rm -f "$log_file"
    return $exit_code
}

# Function to show progress bar
function show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${CYAN}["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "]${NC} ${BOLD}%3d%%${NC} (%d/%d)" $percentage $current $total
}

# Check for --pub flag
PUB_ONLY=false
if [[ "$1" == "--pub" ]]; then
    PUB_ONLY=true
    info "Running in pub-only mode (skipping build_runner)... 📦"
fi

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# Function to process a directory
function process_directory {
    local dir=$1
    local name=$2
    local current=$3
    local total=$4
    
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${MAGENTA}📦 Package ${current}/${total}: ${name}${NC}"
    echo -e "${CYAN}📁 Location: ${dir}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ ! -d "$dir" ]; then
        error_message "Directory $dir not found, skipping..."
        return 1
    fi
    
    if [ ! -f "$dir/pubspec.yaml" ]; then
        error_message "pubspec.yaml not found in $dir, skipping..."
        return 1
    fi
    
    cd "$dir"
    
    # Show package info
    local package_name=$(grep "^name:" pubspec.yaml | sed 's/name: //' | tr -d ' ')
    local package_version=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
    echo -e "${WHITE}📋 Package: ${BOLD}${package_name}${NC} ${WHITE}(v${package_version})${NC}"
    
    # Run flutter pub get with spinner
    echo -e "${YELLOW}📥 Step 1/2: Resolving dependencies...${NC}"
    if run_with_spinner "flutter pub get" "Resolving dependencies for ${name}"; then
        local dep_count=$(flutter pub deps --style=compact 2>/dev/null | wc -l | tr -d ' ')
        success_message "Dependencies installed successfully! (${dep_count} packages)"
    else
        error_message "Failed to install dependencies for ${name}"
        cd "$PROJECT_ROOT"
        return 1
    fi
    
    # Run build_runner if not in pub-only mode
    if [ "$PUB_ONLY" = false ]; then
        echo -e "${YELLOW}🔨 Step 2/2: Running code generation...${NC}"
        if run_with_spinner "dart run build_runner build --delete-conflicting-outputs" "Generating code for ${name}"; then
            success_message "Code generation completed successfully!"
        else
            error_message "Code generation failed for ${name}"
            cd "$PROJECT_ROOT"
            return 1
        fi
    fi
    
    echo -e "${GREEN}${BOLD}✓ ${name} setup completed successfully!${NC}"
    cd "$PROJECT_ROOT"
    return 0
}

# Start the setup process
clear
echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                    🚀 OSMEA PROJECT SETUP SCRIPT 🚀                         ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "$PUB_ONLY" = true ]; then
    echo -e "${YELLOW}📦 Mode: ${BOLD}Pub-only${NC} ${YELLOW}(skipping build_runner)${NC}"
else
    echo -e "${YELLOW}🔨 Mode: ${BOLD}Full setup${NC} ${YELLOW}(pub get + build_runner)${NC}"
fi
echo ""

# Counter for success/failure
SUCCESS_COUNT=0
FAILURE_COUNT=0
CURRENT_INDEX=0

# List of all directories with pubspec.yaml files
DIRECTORIES=(
    "packages/core:Core package"
    "packages/apis:APIs package"
    "packages/components:Components package"
    "projects/storybook:Storybook project"
    "projects/storefront_woo:Storefront Woo project"
    "projects/storefront_supabase:Storefront Supabase project"
    "projects/components_app:Components App project"
    "projects/api_explorer:API Explorer project"
    "projects/admin_dashboard:Admin Dashboard project"
)

# Count total directories
TOTAL_DIRS=${#DIRECTORIES[@]}
if [ -d "./packages/apis/example" ] && [ -f "./packages/apis/example/pubspec.yaml" ]; then
    ((TOTAL_DIRS++))
fi

echo -e "${WHITE}📊 Total packages/projects to process: ${BOLD}${TOTAL_DIRS}${NC}"
echo ""

# Process each directory
for dir_info in "${DIRECTORIES[@]}"; do
    IFS=':' read -r dir name <<< "$dir_info"
    ((CURRENT_INDEX++))
    if process_directory "$dir" "$name" "$CURRENT_INDEX" "$TOTAL_DIRS"; then
        ((SUCCESS_COUNT++))
    else
        ((FAILURE_COUNT++))
    fi
done

# Process example project if it exists
if [ -d "./packages/apis/example" ] && [ -f "./packages/apis/example/pubspec.yaml" ]; then
    ((CURRENT_INDEX++))
    if process_directory "./packages/apis/example" "Example project in APIs package" "$CURRENT_INDEX" "$TOTAL_DIRS"; then
        ((SUCCESS_COUNT++))
    else
        ((FAILURE_COUNT++))
    fi
fi

# Summary
echo ""
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${WHITE}                            📊 SETUP SUMMARY 📊${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Progress bar
PERCENTAGE=$((SUCCESS_COUNT * 100 / TOTAL_DIRS))
WIDTH=60
FILLED=$((SUCCESS_COUNT * WIDTH / TOTAL_DIRS))
EMPTY=$((WIDTH - FILLED))

echo -e "${WHITE}Progress:${NC}"
printf "${GREEN}"
printf "%${FILLED}s" | tr ' ' '█'
printf "${RED}"
printf "%${EMPTY}s" | tr ' ' '░'
printf "${NC}"
echo -e " ${BOLD}${PERCENTAGE}%${NC} (${SUCCESS_COUNT}/${TOTAL_DIRS})"
echo ""

# Statistics
echo -e "${GREEN}${BOLD}✓ Successful:${NC} ${GREEN}${SUCCESS_COUNT}${NC}"
if [ $FAILURE_COUNT -gt 0 ]; then
    echo -e "${RED}${BOLD}✗ Failed:${NC} ${RED}${FAILURE_COUNT}${NC}"
fi
echo ""

if [ $FAILURE_COUNT -eq 0 ]; then
    echo -e "${BOLD}${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ SETUP COMPLETED SUCCESSFULLY! ✅                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ "$PUB_ONLY" = true ]; then
        success_message "All ${TOTAL_DIRS} packages and projects dependencies installed successfully! 🎉"
    else
        success_message "All ${TOTAL_DIRS} packages and projects setup completed! 🎉"
        echo ""
        info "💡 Next steps:"
        echo -e "   ${WHITE}• Run your Flutter app: ${CYAN}flutter run${NC}"
        echo -e "   ${WHITE}• Explore the examples in the projects directory${NC}"
        echo -e "   ${WHITE}• Check out the documentation at: ${CYAN}https://github.com/masterfabric-mobile/osmea${NC}"
    fi
else
    echo -e "${BOLD}${RED}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    ❌ SETUP COMPLETED WITH ERRORS ❌                         ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    error_message "${FAILURE_COUNT} package(s) failed. Please check the errors above."
    echo ""
    warning_message "Some packages may need manual intervention."
    exit 1
fi

# Author information
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${WHITE}👤 Author:${NC} ${BOLD}Gurkan Fikret Gunak${NC} (@gurkanfikretgunak)"
echo -e "${WHITE}🌟 Repository:${NC} ${CYAN}https://github.com/masterfabric-mobile/osmea${NC}"
echo -e "${WHITE}⭐${NC} ${YELLOW}Don't forget to star the project if you find it useful!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
