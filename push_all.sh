#!/usr/bin/env bash
set -e

# 1. Run local pre-push tests if script is present
if [ -f "./test_before_push.sh" ]; then
    echo "Running local pre-push test suite..."
    ./test_before_push.sh
fi

# 2. Stage and commit local changes
git add .
if ! git diff-index --quiet HEAD --; then
    git commit -m "feat: microservice gateway updates and cloudbuild configuration"
else
    echo "No uncommitted changes found. Proceeding with push..."
fi

BRANCH=$(git branch --show-current)

# 3. Push to all 3 actual remotes
echo "Pushing to DEV (origin)..."
git push origin "$BRANCH"

echo "Pushing to STAGING (staging)..."
git push staging "$BRANCH"

echo "Pushing to PROD (prod)..."
git push prod "$BRANCH"

echo "Successfully pushed code across all 3 environment repositories!"
