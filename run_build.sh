#!/usr/bin/env bash
set -e

SHORT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "latest")

echo "Submitting build to Cloud Build with tag: ${SHORT_SHA}..."
gcloud builds submit \
  --config=cloudbuild.yaml \
  --substitutions=SHORT_SHA="${SHORT_SHA}" \
  .
