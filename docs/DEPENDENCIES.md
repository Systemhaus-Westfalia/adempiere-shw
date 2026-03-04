# ADempiere-SHW Dependencies Documentation

**Repository:** Systemhaus-Westfalia/adempiere-shw
**Module:** shw_libs
**Build File:** `/shw_libs/build.gradle`
**Last Updated:** 2026-03-03

---

## Table of Contents

1. [Overview](#overview)
2. [ADempiere Core Dependencies](#adempiere-core-dependencies)
3. [ERPyA Dependencies](#erpya-dependencies)
4. [SHW Custom Dependencies](#shw-custom-dependencies)
5. [Third-Party Libraries](#third-party-libraries)
6. [How to Update Dependencies](#how-to-update-dependencies)
7. [Version Monitoring](#version-monitoring)

---

## Overview

The `adempiere-shw` customization layer depends on several libraries from the ADempiere ecosystem. These dependencies provide core functionality that extends the base ERP capabilities with features like:

- gRPC communication
- Event-driven architecture (Kafka)
- Authentication and authorization (JWT, OpenID)
- File storage (S3)
- Business process automation
- Dashboard and POS enhancements

**Dependency Structure:**

```
adempiere-shw (customizations)
    ↓
shw_libs (build.gradle)
    ↓
    ├── io.github.adempiere (ADempiere packages)
    ├── org.erpya.adempiere.tools (ERPyA tools)
    ├── com.shw (SHW custom libraries)
    └── Third-party libraries (Jackson, POI, etc.)
```

**Key Connection Point:**

The link between `adempiere-shw` and `adempiere-ui-gateway` stack is established through repositories like `adempiere-shw-zk`, which declares:

```gradle
// In adempiere-shw-zk/build.gradle line 56:
implementation 'com.shw:adempiere-shw.shw_libs:3.9.4.001-1.1.49'
```

This means when `shw_libs` is updated with new dependency versions, a new release must be published and referenced in the gateway stack.

---

## ADempiere Core Dependencies

All ADempiere dependencies use the base group ID: `io.github.adempiere`

### 1. adempiere-grpc-utils

**Current Version:** 1.5.5
**Build.gradle Line:** 135

**Purpose:**
Base utilities for gRPC communication in ADempiere. Provides common gRPC client/server functionality, message converters, and utilities for working with Protocol Buffers.

**Why Needed:**
Essential for communication between ADempiere services in the microservices architecture. Used by:
- ZK UI to communicate with backend services
- Vue UI for gRPC-based API calls
- Internal service-to-service communication

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-grpc-utils
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-grpc-utils
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-grpc-utils

**Update Impact:** HIGH
Changes to gRPC utils can affect all service communications. Test thoroughly after updates.

**Check for Updates:**
```bash
# Check Maven Central
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-grpc-utils&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 2. adempiere-dashboard-improvements

**Current Version:** 1.0.8
**Build.gradle Line:** 137

**Purpose:**
Enhancements to the ADempiere dashboard functionality. Provides improved widgets, data visualization, and dashboard customization capabilities.

**Why Needed:**
Extends the standard ADempiere dashboard with custom visualizations and widgets used in Westfalia customizations. Enables:
- Custom dashboard widgets
- Enhanced data visualization
- Real-time dashboard updates
- Custom KPI displays

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-dashboard-improvements
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-dashboard-improvements
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-dashboard-improvements

**Update Impact:** MEDIUM
Dashboard enhancements are typically UI-focused. Test dashboard rendering after updates.

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-dashboard-improvements&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 3. adempiere-pos-improvements

**Current Version:** 1.0.2
**Build.gradle Line:** 139

**Purpose:**
Point of Sale (POS) functionality improvements and extensions. Provides enhanced POS workflows, payment processing, and receipt handling.

**Why Needed:**
Critical for retail/POS operations in Westfalia customizations. Provides:
- Enhanced POS workflows
- Multiple payment method support
- Receipt customization
- Cash drawer management
- POS terminal integration

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-pos-improvements
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-pos-improvements
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-pos-improvements

**Update Impact:** HIGH
POS functionality is business-critical. Thorough testing required, especially payment processing.

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-pos-improvements&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 4. adempiere-business-processors

**Current Version:** 1.1.8
**Build.gradle Line:** 141

**Purpose:**
Business process automation through tasks and schedulers. Provides framework for creating scheduled jobs, background processors, and automated workflows.

**Why Needed:**
Enables automated business processes such as:
- Scheduled report generation
- Automated data imports/exports
- Periodic data synchronization
- Background cleanup tasks
- Automated notifications

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-business-processors
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-business-processors
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-business-processors

**Update Impact:** MEDIUM
Affects scheduled tasks. Verify all schedulers work correctly after updates.

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-business-processors&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 5. adempiere-kafka-connector

**Current Version:** 1.4.9
**Build.gradle Line:** 143

**Purpose:**
Kafka integration for event-driven architecture. Provides queue-based messaging using Apache Kafka for asynchronous processing and inter-service communication.

**Why Needed:**
Enables event-driven architecture for:
- Asynchronous processing of heavy tasks
- Inter-service messaging
- Event sourcing and audit trails
- Scalable background job processing
- Integration with external systems via events

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-kafka-connector
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-kafka-connector
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-kafka-connector

**Update Impact:** HIGH
Core infrastructure component. Affects event processing and async operations.

**Dependencies:**
- Requires Kafka server running in adempiere-ui-gateway stack
- Kafka service configured in docker-compose

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-kafka-connector&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 6. adempiere-jwt-token

**Current Version:** 1.0.4
**Build.gradle Line:** 145

**Purpose:**
JWT (JSON Web Token) authentication for third-party API access. Provides token generation, validation, and authorization for external integrations.

**Why Needed:**
Enables secure API access for:
- Third-party integrations
- Mobile applications
- External systems accessing ADempiere APIs
- Stateless authentication for microservices

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-jwt-token
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-jwt-token
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-jwt-token

**Update Impact:** HIGH
Security-critical component. Test authentication thoroughly after updates.

**Related Dependencies:**
- `com.nimbusds:oauth2-oidc-sdk:9.35`
- `com.nimbusds:nimbus-jose-jwt:9.22`

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-jwt-token&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 7. adempiere-open-id-connector

**Current Version:** 1.0.0
**Build.gradle Line:** 158

**Purpose:**
OpenID Connect integration for SSO (Single Sign-On) with Keycloak and Okta. Provides authentication and authorization through OpenID-based identity providers.

**Why Needed:**
Enables enterprise SSO capabilities:
- Keycloak integration for centralized authentication
- Okta support for cloud-based identity management
- Single Sign-On across ADempiere and other applications
- Centralized user management

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-open-id-connector
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-open-id-connector
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-open-id-connector

**Update Impact:** HIGH
Security and authentication component. Thorough testing required.

**Note:** Listed as "Temporary projects" in build.gradle - may be experimental or under development.

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-open-id-connector&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

### 8. adempiere-s3-connector

**Current Version:** 1.0.7
**Build.gradle Line:** 164

**Purpose:**
AWS S3 integration for file storage. Provides abstraction layer for storing and retrieving files from Amazon S3 or S3-compatible storage (MinIO).

**Why Needed:**
Enables cloud-based file storage for:
- Document attachments
- Report storage
- Image and media files
- Backup storage
- Scalable file management

**Source:**
- **GitHub:** https://github.com/adempiere/adempiere-s3-connector
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-s3-connector
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-s3-connector

**Update Impact:** MEDIUM
File storage operations. Test file upload/download after updates.

**Dependencies:**
- Requires S3-compatible service (AWS S3 or MinIO)
- MinIO service in adempiere-ui-gateway stack

**Related Dependencies:**
- `com.amazonaws:aws-java-sdk-s3:1.11.827`

**Check for Updates:**
```bash
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-s3-connector&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

---

## ERPyA Dependencies

### print-queue

**Current Version:** 1.1.7
**Group ID:** org.erpya.adempiere.tools
**Build.gradle Line:** 159

**Purpose:**
Print queue management for handling print jobs in ADempiere. Manages printer queues, job scheduling, and printer device integration.

**Why Needed:**
Essential for printing operations:
- Print job queuing and management
- Multiple printer support
- Print job status tracking
- Printer configuration

**Source:**
- **GitHub:** https://github.com/erpya/print-queue (likely)
- **Maven Repository:** Hosted on ERPyA GitHub Packages

**Update Impact:** MEDIUM
Affects printing functionality. Test print operations after updates.

**Check for Updates:**
Requires ERPyA repository access. Check releases at:
```
https://github.com/erpya/print-queue/releases
```

---

## SHW Custom Dependencies

### lsv-general

**Current Version:** 1.0.42
**Group ID:** com.shw
**Build.gradle Line:** 161

**Purpose:**
Systemhaus-Westfalia general-purpose library. Contains shared utilities and common functionality used across SHW customizations.

**Why Needed:**
Provides SHW-specific utilities and shared code for customizations.

**Source:**
- **GitHub:** Systemhaus-Westfalia private repository
- **Maven Repository:** GitHub Packages (Systemhaus-Westfalia)

**Update Impact:** Variable
Depends on changes in the specific version. Review release notes.

**Note:** Internal SHW library - version controlled separately from ADempiere ecosystem.

---

### electronic-invoicing-sv (Commented Out)

**Current Version:** 1.0.2 (not active)
**Group ID:** com.shw
**Build.gradle Line:** 162 (commented)

**Purpose:**
Electronic invoicing functionality for El Salvador (SVFE - Sistema de Facturación Electrónica).

**Status:** Currently commented out in build.gradle.

**Note:** Functionality may be implemented elsewhere or deactivated. Check with team before activating.

---

## Third-Party Libraries

The following third-party libraries are also included. These are from public Maven repositories:

### Document Processing
- **iText PDF:** `com.lowagie:itext:2.1.7`, `com.itextpdf:itextpdf:5.5.2`, `com.itextpdf:pdfa:7.1.13`
- **Apache POI:** `org.apache.poi:poi:3.17`, `org.apache.poi:poi-ooxml:3.17` (Excel/Word processing)
- **JasperReports Fonts:** `net.sf.jasperreports:jasperreports-fonts:6.21.0`

### Database Drivers
- **PostgreSQL:** `org.postgresql:postgresql:42.3.3`
- **MariaDB:** `org.mariadb.jdbc:mariadb-java-client:3.0.4`
- **MySQL:** `mysql:mysql-connector-java:5.1.3`
- **Oracle:** `com.oracle.database.jdbc:ojdbc6:11.2.0.4`

### Messaging & Queuing
- **ActiveMQ:** `org.apache.activemq:activemq-core:5.7.0`
- **Telegram Bots:** `org.telegram:telegrambots:6.0.1`

### Storage & File Management
- **AWS S3 SDK:** `com.amazonaws:aws-java-sdk-s3:1.11.827`
- **Commons IO:** `commons-io:commons-io:2.8.0`
- **Sardine (WebDAV):** `com.github.lookfirst:sardine:5.9`

### Barcode & QR Code
- **ZXing:** `com.google.zxing:core:2.3.0`
- **Barcode4J:** `net.sf.barcode4j:barcode4j:2.1`
- **Barbecue:** `net.sourceforge.barbecue:barbecue:1.5-beta1`

### Data Processing
- **Jackson:** `com.fasterxml.jackson.core:jackson-databind:2.0.1`
- **Jackson YAML:** `com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.11.0`
- **Apache Ant:** `org.apache.ant:ant:1.10.5`

### Other Utilities
- **HikariCP (Connection Pooling):** `com.zaxxer:HikariCP:5.0.1`
- **Cron4J (Scheduling):** `it.sauronsoftware.cron4j:cron4j:2.2.5`
- **BeanShell:** `org.beanshell:bsh:2.0b5`
- **Log4j:** `log4j:log4j:1.2.17`

---

## How to Update Dependencies

### Step-by-Step Process

#### 1. Check for Updates

For ADempiere dependencies:

```bash
# Navigate to shw_libs directory from project root
cd adempiere-shw/shw_libs

# Check each dependency (example for grpc-utils)
curl -s "https://search.maven.org/solrsearch/select?q=g:io.github.adempiere+AND+a:adempiere-grpc-utils&rows=1&wt=json" | jq '.response.docs[0].latestVersion'
```

Or visit Maven Central directly:
- https://central.sonatype.com/artifact/io.github.adempiere

#### 2. Update build.gradle

Edit `/shw_libs/build.gradle` and change the version number:

```gradle
// Before
api "${baseGroupId}:adempiere-grpc-utils:1.5.5"

// After (example)
api "${baseGroupId}:adempiere-grpc-utils:1.5.6"
```

#### 3. Test Locally

```bash
# Build the project
./gradlew clean build

# Run tests
./gradlew test

# Verify no compilation errors
./gradlew compileJava
```

#### 4. Publish New Release

Once tested, publish a new version of adempiere-shw:

```bash
# Update version in gradle.properties or root build.gradle
# Example: patchVersion = "3.9.4.001-1.1.50"

# Build and publish
./gradlew publish
```

#### 5. Update adempiere-ui-gateway

Update the reference in `adempiere-shw-zk/build.gradle`:

```gradle
// Before
def adempiereSHWRelease = '3.9.4.001-1.1.49'

// After
def adempiereSHWRelease = '3.9.4.001-1.1.50'
```

Then rebuild and redeploy the gateway stack.

---

## Version Monitoring

### Automated Checking Script

A ready-to-use script is available to check all ADempiere dependencies for updates. The script compares the current version in `build.gradle` with the latest versions available on **both Maven Central and GitHub Packages**.

**Script Location:** `/docs/check-adempiere-deps.sh`

**Usage:**

```bash
# From the docs directory
cd adempiere-shw/docs

# Option 1: Pass token as argument (recommended for security)
./check-adempiere-deps.sh YOUR_GITHUB_TOKEN

# Option 2: Without token (skips GitHub Packages check)
./check-adempiere-deps.sh

# Option 3: Use environment variable
GITHUB_TOKEN="your_token_here" ./check-adempiere-deps.sh
```

**Authentication Priority:**
The script checks for GitHub token in this order:
1. Command-line argument (`$1`)
2. `GITHUB_TOKEN` environment variable
3. `deployToken` in `~/.gradle/gradle.properties`

**Features:**
- ✅ Displays current version from `build.gradle`
- ✅ Fetches latest version from **Maven Central** (public)
- ✅ Fetches latest version from **GitHub Packages** (requires auth)
- ✅ Color-coded status (up to date / update available / source indication)
- ✅ Checks all 8 ADempiere dependencies
- ✅ Shows which repository has the latest version
- ✅ Provides update instructions

**Example Output:**

```
========================================================================
ADempiere Dependencies Version Check
========================================================================

Build file: adempiere-shw/shw_libs/build.gradle
Repositories checked:
  - Maven Central (public)
  - GitHub Packages (requires authentication)

Checking dependencies...

Dependency                          Current    Maven Central GitHub Pkg    Status
----------------------------------- ---------- ------------- ------------- -------------------------
adempiere-grpc-utils                1.5.5      1.4.8         1.5.5         ✓ Latest (GitHub)
adempiere-dashboard-improvements    1.0.8      1.0.8         1.0.8         ✓ Up to date (both)
adempiere-pos-improvements          1.0.2      1.0.2         1.0.2         ✓ Up to date (both)
adempiere-business-processors       1.1.8      1.1.5         1.1.8         ✓ Latest (GitHub)
adempiere-kafka-connector           1.4.9      1.4.2         1.4.9         ✓ Latest (GitHub)
adempiere-jwt-token                 1.0.4      1.0.4         1.0.4         ✓ Up to date (both)
adempiere-open-id-connector         1.0.0      1.0.0         1.0.0         ✓ Up to date (both)
adempiere-s3-connector              1.0.7      1.0.5         1.0.7         ✓ Latest (GitHub)

========================================================================
Legend:
  ✓ Up to date (both)    - Current version matches both sources
  ✓ Latest (GitHub)      - Using latest from GitHub Packages
  ✓ Up to date (Maven)   - Using latest from Maven Central
  ⚠ Newer on GitHub       - GitHub Packages has newer version
  ⚠ Update available      - Newer version available
  ? Unknown               - Cannot determine status
  ✗ Error                 - Could not determine version
========================================================================
```

**System Requirements:**

The script requires the following tools to be installed on your system:

| Tool | Purpose | Required | Package |
|------|---------|----------|---------|
| `curl` | Fetch repository data | ✅ Yes | curl |
| `jq` | Parse JSON from Maven Central API | ✅ Yes | jq |
| `xmllint` | Parse XML from GitHub Packages | ⚠️ Recommended | libxml2-utils |

**Installation:**

```bash
# Ubuntu/Debian
sudo apt install curl jq libxml2-utils

# Mac (xmllint usually pre-installed)
brew install curl jq libxml2

# Verify installation
curl --version
jq --version
xmllint --version
```

**Note about xmllint:**
- `xmllint` is used to parse `maven-metadata.xml` from GitHub Packages
- If not installed, the script falls back to `grep` (less robust but works)
- On most Linux systems, `xmllint` is already installed via `libxml2-utils`
- Test if installed: `command -v xmllint`

**Authentication for GitHub Packages:**

The script needs a GitHub token to check GitHub Packages. It will automatically look for:

1. `GITHUB_TOKEN` environment variable
2. `deployToken` in `~/.gradle/gradle.properties`

To set up authentication:

**Option 1: Environment variable**
```bash
export GITHUB_TOKEN="ghp_your_token_here"
```

**Option 2: Gradle properties**
```bash
# Add to ~/.gradle/gradle.properties
deployToken=ghp_your_token_here
deployUsername=your_github_username
```

**Generate a token:**
- Go to: https://github.com/settings/tokens
- Click "Generate new token (classic)"
- Select scopes: `read:packages`
- Copy the token

**Why Two Repositories?**

ADempiere projects publish to both repositories with different strategies:

- **GitHub Packages**: Primary release location, gets updates first
- **Maven Central**: Secondary location, may lag behind or only receive stable releases

Your `build.gradle` prioritizes repositories in this order:
1. `mavenLocal()` - Local cache (fastest)
2. `maven.pkg.github.com/adempiere/adempiere` - GitHub Packages (primary source)
3. `mavenCentral()` - Maven Central (fallback)

This means Gradle will use GitHub Packages versions when available, which explains why your current versions may be newer than Maven Central's "latest".

### Manual Monitoring

**GitHub Packages:** https://github.com/orgs/adempiere/packages
Check this page regularly for new package versions.

**Maven Central:** https://central.sonatype.com/namespace/io.github.adempiere
All ADempiere packages published here.

### Update Frequency Recommendations

- **Critical dependencies** (grpc-utils, kafka-connector, jwt-token): Check monthly
- **Feature dependencies** (dashboard, pos): Check quarterly
- **Stable dependencies** (s3-connector, open-id): Check semi-annually

---

## Impact Matrix

| Dependency | Business Impact | Technical Complexity | Test Priority |
|------------|----------------|---------------------|---------------|
| adempiere-grpc-utils | HIGH | HIGH | CRITICAL |
| adempiere-kafka-connector | HIGH | HIGH | CRITICAL |
| adempiere-jwt-token | HIGH | MEDIUM | CRITICAL |
| adempiere-pos-improvements | HIGH | MEDIUM | HIGH |
| adempiere-business-processors | MEDIUM | MEDIUM | MEDIUM |
| adempiere-s3-connector | MEDIUM | LOW | MEDIUM |
| adempiere-dashboard-improvements | LOW | LOW | LOW |
| adempiere-open-id-connector | MEDIUM | HIGH | HIGH |

---

## Dependency Graph

```
adempiere-shw.shw_libs
│
├── Core Communication
│   └── adempiere-grpc-utils (gRPC base utilities)
│
├── Authentication & Security
│   ├── adempiere-jwt-token (JWT authentication)
│   └── adempiere-open-id-connector (SSO with Keycloak/Okta)
│
├── Event-Driven Architecture
│   └── adempiere-kafka-connector (Kafka messaging)
│
├── Business Functionality
│   ├── adempiere-pos-improvements (Point of Sale)
│   ├── adempiere-dashboard-improvements (Dashboard widgets)
│   └── adempiere-business-processors (Schedulers & tasks)
│
├── Infrastructure
│   └── adempiere-s3-connector (File storage)
│
├── External Tools
│   └── print-queue (ERPyA - Print management)
│
└── Custom SHW
    └── lsv-general (SHW utilities)
```

---

## Release Notes & Change Tracking

### When Publishing adempiere-shw Updates

Document dependency changes in release notes:

```markdown
## adempiere-shw v3.9.4.001-1.1.50

### Dependency Updates
- Updated adempiere-grpc-utils: 1.5.5 → 1.5.6
  - Improved error handling in gRPC calls
  - Performance optimization for large messages

### Impact
- All gRPC-based API calls now have better error reporting
- Test all Vue UI and ZK UI functionality
```

---

## Related Documentation

- **adempiere-ui-gateway:** https://github.com/Systemhaus-Westfalia/adempiere-ui-gateway
- **adempiere-shw-zk:** https://github.com/Systemhaus-Westfalia/adempiere-shw-zk
- **ADempiere Packages:** https://github.com/orgs/adempiere/packages
- **Maven Central:** https://central.sonatype.com/namespace/io.github.adempiere

---

**Document Version:** 1.0
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Maintained By:** Systemhaus-Westfalia Development Team
