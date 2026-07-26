#!/usr/bin/env bash
set -e

PROJECT_ID="phx-platform-lab"
GITHUB_ORG="scottbakerphx"
POOL_NAME="github-actions-pool"
PROVIDER_NAME="github-provider"

gcloud config set project "$PROJECT_ID"

echo "1. Enabling required GCP security APIs..."
gcloud services enable iamcredentials.googleapis.com \
    sts.googleapis.com \
    iam.googleapis.com

echo "2. Creating shared Workload Identity Pool..."
gcloud iam workload-identity-pools create "$POOL_NAME" \
    --location="global" \
    --description="Shared OIDC pool for GitHub Actions environments" \
    --display-name="GitHub Actions Pool" 2>/dev/null || true

POOL_ID=$(gcloud iam workload-identity-pools describe "$POOL_NAME" \
    --location="global" --format="value(name)")

echo "3. Creating GitHub OIDC Provider..."
gcloud iam workload-identity-pools providers create-oidc "$PROVIDER_NAME" \
    --location="global" \
    --workload-identity-pool="$POOL_NAME" \
    --issuer-uri="https://token.actions.githubusercontent.com" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" 2>/dev/null || true

echo "4. Binding service accounts to your 3 specific GitHub repositories..."

# DEV repo binding (go_capstone_dev)
gcloud iam service-accounts create sa-capstone-dev --display-name="Dev CI/CD SA" 2>/dev/null || true
gcloud iam service-accounts add-iam-policy-binding "sa-capstone-dev@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/${POOL_ID}/attribute.repository/${GITHUB_ORG}/go_capstone_dev"

# STAGING repo binding (go_capstone_staging)
gcloud iam service-accounts create sa-capstone-staging --display-name="Staging CI/CD SA" 2>/dev/null || true
gcloud iam service-accounts add-iam-policy-binding "sa-capstone-staging@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/${POOL_ID}/attribute.repository/${GITHUB_ORG}/go_capstone_staging"

# PROD repo binding (go_capstone_production)
gcloud iam service-accounts create sa-capstone-prod --display-name="Prod CI/CD SA" 2>/dev/null || true
gcloud iam service-accounts add-iam-policy-binding "sa-capstone-prod@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/${POOL_ID}/attribute.repository/${GITHUB_ORG}/go_capstone_production"

echo "OIDC Setup Complete for project: ${PROJECT_ID}!"
