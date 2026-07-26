#!/usr/bin/env bash
set -e

echo "=== 1. Checking Artifact Registry ==="
gcloud artifacts repositories list --location=us-central1

echo -e "\n=== 2. Checking Cloud Run Services ==="
gcloud run services list --region=us-central1

echo -e "\n=== 3. Checking Workload Identity Pool ==="
gcloud iam workload-identity-pools list --location=global
