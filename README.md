# 🚀 Platform Engineering Microservice Gateway

An automated, cloud-native Go microservice gateway deployed to Google Cloud Run using modern Platform Engineering principles, keyless OpenID Connect (OIDC) authentication via Workload Identity Federation, and local pre-push testing.

---

## 🏛️ Multi-Environment Architecture & Promotion

| Environment | Repository | Remote | Description |
| :--- | :--- | :--- | :--- |
| DEV | capstone_dev | origin | Active feature development & automated unit/integration tests |
| STAGING | capstone_staging | staging | Pre-production validation and environmental parity testing |
| PROD | capstone_prod | prod | Production environment for live traffic releases |

---

## 🔒 Security & Quality Controls

* Runtime: Go 1.26 on a minimal Alpine Linux base container (< 20MB).
* Cloud Infrastructure: Google Cloud Run (us-central1) + Google Artifact Registry.
* Authentication: Keyless Workload Identity Federation (OIDC) across all 3 GitHub Action environments. Zero long-lived GCP keys stored.
* Shift-Left Quality: Automated .git/hooks/pre-push local container integration test suite.

---

## 🚦 Endpoints

| Endpoint | Method | Response | Description |
| :--- | :--- | :--- | :--- |
| /health | GET | 200 OK (JSON) | Health probe returning uptime and service status. |
| /metrics | GET | 200 OK (JSON) | Basic runtime telemetry and system status. |

---

## 🧪 Local Pre-Push Testing

This repository enforces local verification before code reaches any remote environment:

  ./test_before_push.sh

---

## 📄 Platform Documentation

* PLATFORM_ENGINEERING_GUIDE.md — Technical blueprint and setup history.
* PROJECT_STATE.md — Operational multi-environment state tracker.
