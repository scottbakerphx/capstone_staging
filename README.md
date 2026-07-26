# 🚀 Platform Engineering Microservice Gateway

An automated, cloud-native Go microservice gateway deployed to Google Cloud Run using modern Platform Engineering principles, keyless OpenID Connect (OIDC) authentication via Workload Identity Federation, and local pre-push testing.

## 🏛️ Multi-Environment Architecture & Promotion

| Environment | Repository | Remote | Description |
| :--- | :--- | :--- | :--- |
| **DEV** | `capstone_dev` | `origin` | Active feature development & automated unit/integration tests |
| **STAGING** | `capstone_staging` | `staging` | Pre-production validation and environmental parity testing |
| **PROD** | `capstone_prod` | `prod` | Production environment for live traffic releases |

## 🔒 Security & Quality Controls

*   **Runtime:** Go 1.26 on a minimal Alpine Linux base container (< 20MB).
*   **Cloud Infrastructure:** Google Cloud Run (us-central1) + Google Artifact Registry.
*   **Authentication:** Keyless Workload Identity Federation (OIDC) across all 3 GitHub Action environments. Zero long-lived GCP keys stored.
*   **IAM Permissions:** Strictly scoped service accounts per environment, requiring explicit `roles/artifactregistry.writer`, `roles/run.admin`, and `roles/iam.serviceAccountUser` bindings.
*   **Shift-Left Quality:** Automated `.git/hooks/pre-push` local container integration test suite.

## 🚦 Endpoints

| Endpoint | Method | Response | Description |
| :--- | :--- | :--- | :--- |
| `/health` | GET | 200 OK (JSON) | Health probe returning uptime and service status. |
| `/metrics` | GET | 200 OK (JSON) | Basic runtime telemetry and system status. |

---

## 🛠️ Local Development & Testing

### 1. Local Pre-Push Testing
This repository enforces local verification before code reaches any remote environment. Do not push without running:

    ./test_before_push.sh

### 2. SonarQube Local Scanning
Before CI/CD takes over, code quality and security are analyzed locally using the SonarQube CLI (`sonar-scanner-cli`). 
*   **Why we use it:** To catch bugs, vulnerabilities, and "Code Smells" before they consume pipeline minutes. 
*   **Configuration:** Governed by `sonar-project.properties`, which tells the scanner exactly what to analyze, what to ignore (like vendor files), and where to find the Go coverage reports (`coverage.out`). Security "Hotspots" (like open ports) require manual approval in the Sonar dashboard.

### 3. Cloudflare Tunnel (`cloudflared`)
*   **Why we use it:** To securely expose the local Go gateway to the internet without opening router ports or messing with firewalls. This is critical for testing live external webhooks or simulating production traffic against the local Arch Linux development environment securely.

---

## 🏗️ CI/CD Pipeline & Orchestration

This project utilizes isolated service accounts (`sa-capstone-dev`, `sa-capstone-staging`, `sa-capstone-prod`) to deploy code. 

### GitHub Actions vs. Cloud Build (`cloudbuild.yaml`)
*   **GitHub Actions (`deploy.yml`):** Our primary CI/CD orchestrator. It uses OIDC to securely log into GCP, runs the Sonar/GoSec scans, builds the Docker image, and triggers the Cloud Run deployment.
*   **Google Cloud Build (`cloudbuild.yaml`):** Included as the GCP-native alternative for container builds. **Why we use/include it:** If we ever need to bypass GitHub Actions and execute builds directly inside Google Cloud's infrastructure (e.g., for closer integration with GCP internal services or triggering builds directly from GCP source repositories), `cloudbuild.yaml` provides the exact declarative steps to build, tag, and push the image to Artifact Registry natively.

---

## 📄 Platform Documentation

*   `PLATFORM_ENGINEERING_GUIDE.md` — Technical blueprint and setup history.
*   `PROJECT_STATE.md` — Operational multi-environment state tracker.
