# 🚀 Platform Engineering Microservice Gateway — DEV Environment

[![CI/CD Pipeline](https://github.com/scottbakerphx/capstone_dev/actions/workflows/deploy.yml/badge.svg)](https://github.com/scottbakerphx/capstone_dev/actions)

An automated, cloud-native Go microservice gateway deployed to **Google Cloud Run** using modern **Platform Engineering** principles, keyless authentication, and local pre-push testing.

---

## 🏛️ Architecture Overview

* **Runtime:** Go 1.26 running on a minimal Alpine Linux container base (`< 20MB`).
* **Cloud Infrastructure:** Google Cloud Run (`us-central1`) + Google Artifact Registry.
* **Authentication:** **Workload Identity Federation (OIDC)** — Keyless CI/CD integration with GitHub Actions. Zero static GCP service account keys.
* **Local Shift-Left Quality:** Automated `.git/hooks/pre-push` local container integration test suite.

---

## 🚦 Endpoints

| Endpoint | Method | Response | Description |
| :--- | :--- | :--- | :--- |
| `/health` | `GET` | `200 OK` (JSON) | Health probe bypasses edge proxies and returns service uptime. |
| `/metrics` | `GET` | `200 OK` (JSON) | Basic runtime telemetry and system status. |

---

## 🧪 Local Pre-Push Testing

This repository enforces local agentic testing before any code reaches remote branches:

```bash
./test_before_push.sh
```

---

## 📄 Platform Documentation

For full step-by-step platform execution details and session history, see:
* [`PLATFORM_ENGINEERING_GUIDE.md`](./PLATFORM_ENGINEERING_GUIDE.md) — Comprehensive technical blueprint.
* [`PROJECT_STATE.md`](./PROJECT_STATE.md) — Multi-environment architectural state.
