# ADempiere-SHW Dependencies Documentation

**Repository:** Systemhaus-Westfalia/adempiere-shw
**Module:** shw_libs
**Build File:** `/shw_libs/build.gradle`
**Last Updated:** 2026-03-31

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

**Current Version:** 1.6.4
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-grpc-utils *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-grpc-utils

**Update Impact:** HIGH
Changes to gRPC utils can affect all service communications. Test thoroughly after updates.

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-grpc-utils/releases/latest" | jq -r '.tag_name'
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-dashboard-improvements *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-dashboard-improvements

**Update Impact:** MEDIUM
Dashboard enhancements are typically UI-focused. Test dashboard rendering after updates.

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-dashboard-improvements/releases/latest" | jq -r '.tag_name'
```

---

### 3. adempiere-pos-improvements

**Current Version:** 1.0.4
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-pos-improvements *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-pos-improvements

**Update Impact:** HIGH
POS functionality is business-critical. Thorough testing required, especially payment processing.

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-pos-improvements/releases/latest" | jq -r '.tag_name'
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-business-processors *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-business-processors

**Update Impact:** MEDIUM
Affects scheduled tasks. Verify all schedulers work correctly after updates.

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-business-processors/releases/latest" | jq -r '.tag_name'
```

---

### 5. adempiere-kafka-connector

**Current Version:** 1.5.1
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-kafka-connector *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-kafka-connector

**Update Impact:** HIGH
Core infrastructure component. Affects event processing and async operations.

**Dependencies:**
- Requires Kafka server running in adempiere-ui-gateway stack
- Kafka service configured in docker-compose

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-kafka-connector/releases/latest" | jq -r '.tag_name'
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-jwt-token *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-jwt-token

**Update Impact:** HIGH
Security-critical component. Test authentication thoroughly after updates.

**Related Dependencies:**
- `com.nimbusds:oauth2-oidc-sdk:9.35`
- `com.nimbusds:nimbus-jose-jwt:9.22`

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-jwt-token/releases/latest" | jq -r '.tag_name'
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-open-id-connector *(informational only — lags behind GitHub Packages)*
- **GitHub Packages:** https://github.com/orgs/adempiere/packages?repo_name=adempiere-open-id-connector

**Update Impact:** HIGH
Security and authentication component. Thorough testing required.

**Note:** Listed as "Temporary projects" in build.gradle - may be experimental or under development.

**Check for Updates:**
```bash
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-open-id-connector/releases/latest" | jq -r '.tag_name'
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
- **Maven Central:** https://central.sonatype.com/artifact/io.github.adempiere/adempiere-s3-connector *(informational only — lags behind GitHub Packages)*
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
# Via script (checks all dependencies at once)
cd adempiere-shw/docs && ./check-adempiere-deps.sh

# Or check this dependency directly
curl -s "https://api.github.com/repos/adempiere/adempiere-s3-connector/releases/latest" | jq -r '.tag_name'
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

**Current Version:** 1.0.46
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

# Check all dependencies at once
cd adempiere-shw/docs
./check-adempiere-deps.sh
```

> **Note:** Maven Central also lists these packages but lags behind. Do not use it to determine whether an update is available.

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
# Example: patchVersion = "3.9.4.001-1.1.53"

# Build and publish
./gradlew publish
```

#### 5. Update adempiere-ui-gateway

Update the reference in `adempiere-shw-zk/build.gradle`:

```gradle
// Before
def adempiereSHWRelease = '3.9.4.001-1.1.52'

// After
def adempiereSHWRelease = '3.9.4.001-1.1.53'
```

Then rebuild and redeploy the gateway stack.

---

## Version Monitoring

### Automated Checking Script

A ready-to-use script is available to check all ADempiere dependencies for updates. The script compares the current version in `build.gradle` with the latest versions from **GitHub Releases** (authoritative, public, no authentication required). Maven Central is shown as a reference column only — it lags behind and should not be used to decide whether an update is needed.

**Script Location:** `/docs/check-adempiere-deps.sh`

**Usage:**

```bash
# From the docs directory
cd adempiere-shw/docs
./check-adempiere-deps.sh
```

No token or authentication needed.

**Features:**
- ✅ Displays current version from `build.gradle`
- ✅ Fetches latest version from **GitHub Releases** (authoritative, public)
- ✅ Shows **Maven Central** version as a reference column (informational only)
- ✅ Color-coded status (up to date / update available / ahead of release)
- ✅ Checks all 8 ADempiere dependencies
- ✅ Provides update instructions

**Example Output:**

```
========================================================================
ADempiere Dependencies Version Check
========================================================================

Build file: adempiere-shw/shw_libs/build.gradle
Repositories checked:
  - GitHub Releases (authoritative, public, no auth needed)
  - Maven Central   (reference, may lag behind)

Checking dependencies...

Dependency                          Current    GH Release    Maven Ctrl    Status
----------------------------------- ---------- ------------- ------------- -----------------------------------
adempiere-grpc-utils                1.6.4      1.6.4         1.5.5         ✓ Up to date
adempiere-dashboard-improvements    1.0.8      1.0.8         1.0.8         ✓ Up to date
adempiere-pos-improvements          1.0.4      1.0.4         1.0.2         ✓ Up to date
adempiere-business-processors       1.1.8      1.1.8         1.1.5         ✓ Up to date
adempiere-kafka-connector           1.5.1      1.5.1         1.4.2         ✓ Up to date
adempiere-jwt-token                 1.0.4      1.0.4         1.0.4         ✓ Up to date
adempiere-open-id-connector         1.0.0      1.0.0         1.0.0         ✓ Up to date
adempiere-s3-connector              1.0.7      1.0.7         1.0.5         ✓ Up to date

========================================================================
Legend:
  ✓ Up to date                   - Current matches latest GitHub Release
  ✓ Up to date (Maven)           - Matches Maven Central (no GH Release found)
  ↑ Ahead of latest release      - Current is newer than latest release
  ⚠ Update available: X → Y      - GitHub Release Y is newer than current X
  ✗ Not found in build.gradle    - Dependency not found
========================================================================
```

**System Requirements:**

| Tool | Purpose | Required | Install |
|------|---------|----------|---------|
| `curl` | Fetch repository data | ✅ Yes | `sudo apt install curl` |
| `jq` | Parse JSON responses | ✅ Yes | `sudo apt install jq` |

**Installation:**

```bash
# Ubuntu/Debian
sudo apt install curl jq
```

### Manual Monitoring

**GitHub Releases:** https://github.com/adempiere
Navigate to each library repository and check the Releases tab. This is the authoritative source.

> **Note:** These packages also appear on Maven Central (`https://central.sonatype.com/namespace/io.github.adempiere`) but that mirror lags behind. Never use Maven Central to decide whether an update is available for `io.github.adempiere` packages.

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
- **Maven Central** *(informational only)*: https://central.sonatype.com/namespace/io.github.adempiere

---

**Document Version:** 1.0
**Created:** 2026-03-03
**Last Updated:** 2026-03-31
**Maintained By:** Systemhaus-Westfalia Development Team
