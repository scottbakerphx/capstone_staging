#!/usr/bin/env bash
set -e

echo "Spinning up platform infrastructure via Pulumi..."
pulumi up -y

echo "Verifying active Artifact Registry repositories..."
gcloud artifacts repositories list --location=us-central1
