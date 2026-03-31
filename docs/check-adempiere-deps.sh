#!/bin/bash
# File: check-adempiere-deps.sh
# Purpose: Check ADempiere dependencies in shw_libs/build.gradle for updates
# Location: adempiere-shw/docs/
# Checks Maven Central and GitHub Releases (authoritative source, no auth required)
#
# Requirements:
#   - curl: HTTP client for fetching repository data
#   - jq: JSON parser for API responses
#
# Usage:
#   ./check-adempiere-deps.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Path to build.gradle
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_GRADLE="$SCRIPT_DIR/../shw_libs/build.gradle"

# Check if build.gradle exists
if [ ! -f "$BUILD_GRADLE" ]; then
    echo -e "${RED}Error: build.gradle not found at $BUILD_GRADLE${NC}"
    exit 1
fi

# Check if required tools are installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required. Install it: sudo apt install jq${NC}"
    exit 1
fi
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is required but not installed.${NC}"
    exit 1
fi

echo "========================================================================"
echo "ADempiere Dependencies Version Check"
echo "========================================================================"
echo ""
echo "Build file: $BUILD_GRADLE"
echo "Repositories checked:"
echo "  - GitHub Releases (authoritative, public, no auth needed)"
echo "  - Maven Central   (reference, may lag behind)"
echo ""
echo "Checking dependencies..."
echo ""

# Function to extract current version from build.gradle
get_current_version() {
    local artifact=$1
    grep -E "api \"\\\${baseGroupId}:${artifact}:" "$BUILD_GRADLE" \
        | sed -E "s/.*:([0-9]+\.[0-9]+\.[0-9]+).*/\1/"
}

# Function to get latest version from GitHub Releases (public, no auth)
get_github_releases_version() {
    local artifact=$1
    local tag
    tag=$(curl -s "https://api.github.com/repos/adempiere/${artifact}/releases/latest" 2>/dev/null \
        | jq -r '.tag_name // "N/A"')
    # Strip leading 'v' prefix if present
    echo "${tag#v}"
}

# Function to get latest version from Maven Central (reference only)
get_maven_central_version() {
    local artifact=$1
    curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:${artifact}&rows=1&wt=json" \
        2>/dev/null | jq -r '.response.docs[0].latestVersion // "N/A"'
}

# Semantic version comparison: returns 0 if a >= b, 1 if a < b
version_gte() {
    [ "$(printf '%s\n%s' "$1" "$2" | sort -V | head -1)" = "$2" ]
}

# Compare and produce status
compare_versions() {
    local current=$1
    local releases=$2
    local maven=$3

    if [ "$current" = "N/A" ]; then
        echo -e "${RED}✗ Not found in build.gradle${NC}"
        return
    fi

    if [ "$releases" = "N/A" ]; then
        # Fall back to Maven Central
        if [ "$current" = "$maven" ]; then
            echo -e "${GREEN}✓ Up to date (Maven)${NC}"
        elif version_gte "$current" "$maven"; then
            echo -e "${CYAN}↑ Ahead of Maven Central${NC}"
        else
            echo -e "${YELLOW}⚠ Update: ${current} → ${maven} (Maven)${NC}"
        fi
        return
    fi

    if [ "$current" = "$releases" ]; then
        echo -e "${GREEN}✓ Up to date${NC}"
    elif version_gte "$current" "$releases"; then
        echo -e "${CYAN}↑ Ahead of latest release${NC}"
    else
        echo -e "${YELLOW}⚠ Update available: ${current} → ${releases}${NC}"
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
printf "%-35s %-10s %-13s %-13s %-35s\n" \
    "Dependency" "Current" "GH Release" "Maven Ctrl" "Status"
printf "%-35s %-10s %-13s %-13s %-35s\n" \
    "-----------------------------------" "----------" "-------------" "-------------" "-----------------------------------"

# Check each dependency
for dep in "${DEPS[@]}"; do
    current=$(get_current_version "$dep")
    releases=$(get_github_releases_version "$dep")
    maven=$(get_maven_central_version "$dep")

    [ -z "$current" ] && current="N/A"

    printf "%-35s %-10s %-13s %-13s " "$dep" "$current" "$releases" "$maven"
    compare_versions "$current" "$releases" "$maven"
done

echo ""
echo "========================================================================"
echo "Legend:"
echo -e "  ${GREEN}✓ Up to date${NC}                   - Current matches latest GitHub Release"
echo -e "  ${GREEN}✓ Up to date (Maven)${NC}           - Matches Maven Central (no GH Release found)"
echo -e "  ${CYAN}↑ Ahead of latest release${NC}      - Current is newer than latest release"
echo -e "  ${YELLOW}⚠ Update available: X → Y${NC}      - GitHub Release Y is newer than current X"
echo -e "  ${RED}✗ Not found in build.gradle${NC}    - Dependency not found"
echo ""
echo "Authoritative source: GitHub Releases (github.com/adempiere/<library>/releases)"
echo "Maven Central may lag behind — do not rely on it for update decisions."
echo ""
echo "To update a dependency:"
echo "  1. Edit $BUILD_GRADLE"
echo "  2. Change the version number"
echo "  3. Test: cd /data2/entwicklung/westfaliaRepository_2022-06/adempiere-shw && ./gradlew clean build"
echo "========================================================================"
