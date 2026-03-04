#!/bin/bash
# File: check-adempiere-deps.sh
# Purpose: Check ADempiere dependencies in shw_libs/build.gradle for updates
# Location: adempiere-shw/docs/
# Checks both Maven Central and GitHub Packages
#
# Requirements:
#   - curl: HTTP client for fetching repository data
#   - jq: JSON parser for Maven Central API responses
#   - xmllint: XML parser for GitHub Packages maven-metadata.xml (optional, has grep fallback)
#
# Install xmllint:
#   Ubuntu/Debian: sudo apt install libxml2-utils
#   Mac: brew install libxml2 (usually pre-installed)
#
# Authentication:
#   Set GITHUB_TOKEN environment variable or add deployToken to ~/.gradle/gradle.properties
#   Generate token at: https://github.com/settings/tokens (scope: read:packages)
#
# Usage:
#   ./check-adempiere-deps.sh YOUR_GITHUB_TOKEN
#   ./check-adempiere-deps.sh
#   GITHUB_TOKEN="ghp_xxx" ./check-adempiere-deps.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Path to build.gradle
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_GRADLE="$SCRIPT_DIR/../shw_libs/build.gradle"

# GitHub authentication - Priority order:
# 1. Command-line argument ($1)
# 2. GITHUB_TOKEN environment variable
# 3. deployToken from ~/.gradle/gradle.properties
GITHUB_TOKEN="${1:-}"
if [ -z "$GITHUB_TOKEN" ]; then
    GITHUB_TOKEN="${GITHUB_TOKEN:-}"
fi
if [ -z "$GITHUB_TOKEN" ]; then
    # Try to read from gradle.properties
    GRADLE_PROPS="$HOME/.gradle/gradle.properties"
    if [ -f "$GRADLE_PROPS" ]; then
        GITHUB_TOKEN=$(grep "^deployToken=" "$GRADLE_PROPS" 2>/dev/null | cut -d'=' -f2)
    fi
fi

# Check if build.gradle exists
if [ ! -f "$BUILD_GRADLE" ]; then
    echo -e "${RED}Error: build.gradle not found at $BUILD_GRADLE${NC}"
    exit 1
fi

# Check if required tools are installed
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Warning: jq is not installed. Install it for better JSON parsing.${NC}"
    echo "  Ubuntu/Debian: sudo apt install jq"
    echo "  Mac: brew install jq"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is required but not installed.${NC}"
    exit 1
fi

if ! command -v xmllint &> /dev/null; then
    echo -e "${YELLOW}Warning: xmllint is not installed. GitHub Packages check will be limited.${NC}"
    echo "  Ubuntu/Debian: sudo apt install libxml2-utils"
    echo "  Mac: brew install libxml2"
fi

echo "========================================================================"
echo "ADempiere Dependencies Version Check"
echo "========================================================================"
echo ""
echo "Build file: $BUILD_GRADLE"
echo "Repositories checked:"
echo "  - Maven Central (public)"
echo "  - GitHub Packages (requires authentication)"
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${YELLOW}⚠ GitHub token not found. GitHub Packages check will be skipped.${NC}"
    echo "  Pass token as argument: ./check-adempiere-deps.sh YOUR_TOKEN"
    echo "  Or set GITHUB_TOKEN environment variable"
    echo "  Or add deployToken to ~/.gradle/gradle.properties"
    echo ""
fi

echo "Checking dependencies..."
echo ""

# Function to extract current version from build.gradle
get_current_version() {
    local artifact=$1
    local version=$(grep -E "api \"\\\${baseGroupId}:${artifact}:" "$BUILD_GRADLE" | sed -E "s/.*:([0-9]+\.[0-9]+\.[0-9]+).*/\1/")
    echo "$version"
}

# Function to get latest version from Maven Central
get_maven_central_version() {
    local artifact=$1
    local latest=$(curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:$artifact&rows=1&wt=json" 2>/dev/null | jq -r '.response.docs[0].latestVersion // "N/A"')
    echo "$latest"
}

# Function to get latest version from GitHub Packages
get_github_packages_version() {
    local artifact=$1

    if [ -z "$GITHUB_TOKEN" ]; then
        echo "N/A"
        return
    fi

    # GitHub Packages uses Maven repository structure
    # URL: https://maven.pkg.github.com/adempiere/adempiere/io/github/adempiere/{artifact}/maven-metadata.xml
    local metadata_url="https://maven.pkg.github.com/adempiere/adempiere/io/github/adempiere/${artifact}/maven-metadata.xml"

    # Fetch maven-metadata.xml with authentication
    local response=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "$metadata_url" 2>/dev/null)

    # Extract latest version using xmllint if available, otherwise use grep/sed
    if command -v xmllint &> /dev/null; then
        local latest=$(echo "$response" | xmllint --xpath "string(//metadata/versioning/latest)" - 2>/dev/null)
    else
        local latest=$(echo "$response" | grep -oP '(?<=<latest>)[^<]+' 2>/dev/null | head -n1)
    fi

    if [ -z "$latest" ]; then
        echo "N/A"
    else
        echo "$latest"
    fi
}

# Function to compare versions and determine source
compare_versions() {
    local current=$1
    local maven=$2
    local github=$3

    if [ "$current" == "N/A" ]; then
        echo -e "${RED}✗ Error${NC}"
        return
    fi

    # Determine which source has the current version
    if [ "$current" == "$maven" ] && [ "$current" == "$github" ]; then
        echo -e "${GREEN}✓ Up to date (both)${NC}"
    elif [ "$current" == "$github" ] && [ "$github" != "N/A" ]; then
        if [ "$maven" != "N/A" ] && [ "$github" != "$maven" ]; then
            echo -e "${GREEN}✓ Latest (GitHub)${NC}"
        else
            echo -e "${GREEN}✓ Up to date (GitHub)${NC}"
        fi
    elif [ "$current" == "$maven" ]; then
        if [ "$github" != "N/A" ] && [ "$github" != "$maven" ]; then
            echo -e "${YELLOW}⚠ Newer on GitHub${NC}"
        else
            echo -e "${GREEN}✓ Up to date (Maven)${NC}"
        fi
    else
        # Current doesn't match either - check if updates available
        local has_update=false
        if [ "$maven" != "N/A" ] && [ "$maven" != "$current" ]; then
            has_update=true
        fi
        if [ "$github" != "N/A" ] && [ "$github" != "$current" ]; then
            has_update=true
        fi
        if $has_update; then
            echo -e "${YELLOW}⚠ Update available${NC}"
        else
            echo -e "${CYAN}? Unknown${NC}"
        fi
    fi
}

# Array of dependencies to check
DEPS=(
    "adempiere-grpc-utils"
    "adempiere-dashboard-improvements"
    "adempiere-pos-improvements"
    "adempiere-business-processors"
    "adempiere-kafka-connector"
    "adempiere-jwt-token"
    "adempiere-open-id-connector"
    "adempiere-s3-connector"
)

# Header
printf "%-35s %-10s %-13s %-13s %-25s\n" "Dependency" "Current" "Maven Central" "GitHub Pkg" "Status"
printf "%-35s %-10s %-13s %-13s %-25s\n" "-----------------------------------" "----------" "-------------" "-------------" "-------------------------"

# Check each dependency
for dep in "${DEPS[@]}"; do
    current=$(get_current_version "$dep")
    maven=$(get_maven_central_version "$dep")
    github=$(get_github_packages_version "$dep")

    if [ -z "$current" ] || [ "$current" == "" ]; then
        current="N/A"
    fi

    printf "%-35s %-10s %-13s %-13s " "$dep" "$current" "$maven" "$github"
    compare_versions "$current" "$maven" "$github"
done

echo ""
echo "========================================================================"
echo "Legend:"
echo -e "  ${GREEN}✓ Up to date (both)${NC}    - Current version matches both sources"
echo -e "  ${GREEN}✓ Latest (GitHub)${NC}      - Using latest from GitHub Packages"
echo -e "  ${GREEN}✓ Up to date (Maven)${NC}   - Using latest from Maven Central"
echo -e "  ${YELLOW}⚠ Newer on GitHub${NC}       - GitHub Packages has newer version"
echo -e "  ${YELLOW}⚠ Update available${NC}      - Newer version available"
echo -e "  ${CYAN}? Unknown${NC}               - Cannot determine status"
echo -e "  ${RED}✗ Error${NC}                 - Could not determine version"
echo ""
echo "Repository Priority (in build.gradle):"
echo "  1. mavenLocal() - Local cache"
echo "  2. maven.pkg.github.com/adempiere/adempiere - GitHub Packages"
echo "  3. mavenCentral() - Maven Central"
echo ""
echo "Note: Gradle uses the first repository where a version is found."
echo ""
echo "To update a dependency:"
echo "  1. Edit $BUILD_GRADLE"
echo "  2. Change version number for the dependency"
echo "  3. Test: cd ../shw_libs && ./gradlew clean build"
echo "  4. Publish new adempiere-shw release"
echo "========================================================================"
