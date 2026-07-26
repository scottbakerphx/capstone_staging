# 🚀 Platform Engineering Microservice Gateway

![SonarQube Quality Gate](https://img.shields.io/badge/SonarQube-PASSED-brightgreen?style=for-the-badge&logo=sonarqube)
![Coverage](https://img.shields.io/badge/Coverage-86.0%25-brightgreen?style=for-the-badge&logo=go)
![GCP Cloud Run](https://img.shields.io/badge/Google_Cloud_Run-Deployed-4285F4?style=for-the-badge&logo=googlecloud)
![Architecture](https://img.shields.io/badge/Architecture-Alpine_Linux-0D597F?style=for-the-badge&logo=alpine-linux)

An automated, cloud-native Go microservice gateway deployed to Google Cloud Run using modern Platform Engineering principles, keyless OpenID Connect (OIDC) authentication via Workload Identity Federation, and local pre-push testing.

---

## 🏛️ Multi-Environment Architecture & Promotion

| Environment | Repository | Remote | Description |
| :--- | :--- | :--- | :--- |
| **DEV** | `capstone_dev` | `origin` | Active feature development & automated unit/integration tests |
| **STAGING** | `capstone_staging` | `staging` | Pre-production validation and environmental parity testing |
| **PROD** | `capstone_prod` | `prod` | Production environment for live traffic releases |

---

## 🛣️ The Golden Path (Internal Developer Platform)

This repository provides a frictionless "Golden Path" for developers. The infrastructure is abstracted, allowing developers to focus solely on business logic while the platform handles security, builds, and deployment.

### Stage 1: The Inner Loop (Developer Workstation)
*   **Local Go 1.26** development environment.
*   **Cloudflare Tunnel (`cloudflared`)** for securely testing external webhooks without opening firewall ports.
*   **Pre-Flight Checks:** Local SonarQube CLI scanning and `.git/hooks/pre-push` scripts to block bad commits before they leave the workstation.

### Stage 2: Automated Quality & Security Gates
*   Automated GitHub Actions trigger on push.
*   Go unit testing, coverage reporting (`86.0%`), and GoSec vulnerability scans.
*   SonarQube quality gate enforcement (**PASSED**).

### Stage 3: Zero-Trust Artifact Delivery
*   **Keyless Authentication:** Workload Identity Federation (WIF) via OIDC tokens (zero static GCP keys stored).
*   **Containerization:** Minimal (< 20MB) Alpine Linux Docker builds running as non-root `appuser`.
*   **Artifact Registry:** Automated, secure image tagging and pushing.

### Stage 4: Progressive Multi-Environment Promotion
*   Environment isolation via dedicated Service Accounts (`sa-capstone-dev`, `sa-capstone-staging`, `sa-capstone-prod`).
*   Automated zero-downtime deployment to **Google Cloud Run**.

---

## 🔒 Security & Quality Controls

*   **Runtime:** Go 1.26 on a minimal Alpine Linux base container.
*   **Cloud Infrastructure:** Google Cloud Run (`us-central1`) + Google Artifact Registry.
*   **Authentication:** Keyless Workload Identity Federation (OIDC) across all 3 GitHub Action environments.
*   **IAM Permissions:** Strictly scoped service accounts requiring explicit `roles/artifactregistry.writer`, `roles/run.admin`, and `roles/iam.serviceAccountUser` bindings.

---

## 🚦 Endpoints

| Endpoint | Method | Response | Description |
| :--- | :--- | :--- | :--- |
| `/health` | GET | 200 OK (JSON) | Health probe returning uptime and service status. |
| `/metrics` | GET | 200 OK (JSON) | Basic runtime telemetry and system status. |

---

## 🛠️ Local Development & Testing

### 1. Local Pre-Push Testing
This repository enforces local verification before code reaches any remote environment using `./push_all.sh`.

### 2. SonarQube Local Scanning
Before CI/CD takes over, code quality and security are analyzed locally.
*   **Configuration:** Governed by `sonar-project.properties`. Security "Hotspots" and coverage reports are validated against global Quality Gates.

---

## 🏗️ CI/CD Pipeline & Orchestration

*   **GitHub Actions (`deploy.yml`):** Our primary CI/CD orchestrator. It uses OIDC to securely log into GCP, runs scans, builds the Docker image, and triggers Cloud Run.
*   **Google Cloud Build (`cloudbuild.yaml`):** Included as the GCP-native alternative for container builds in case we ever need to bypass GitHub Actions and execute builds directly inside Google Cloud's infrastructure.

---

## 📄 Platform Documentation

*   `PLATFORM_ENGINEERING_GUIDE.md` — Technical blueprint and setup history.
*   `PROJECT_STATE.md` — Operational multi-environment state tracker.
