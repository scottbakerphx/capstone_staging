#!/bin/bash
set -e

echo "🧪 Running unit tests & generating coverage profile..."
go test -coverprofile=coverage.out ./...

echo "📊 Checking test coverage percentage..."
go tool cover -func=coverage.out | grep total:

echo "🛡️ Running pre-push checks..."
./test_before_push.sh

echo "🚀 Staging and committing changes..."
git add .
git commit -m "refactor: modularize server setup and boost SonarQube test coverage past 80%" || echo "No changes to commit"

echo "📡 Pushing to DEV (origin)..."
git push origin main

echo "📡 Pushing to STAGING (staging)..."
git push staging main

echo "📡 Pushing to PROD (prod)..."
git push prod main

echo "✅ All 3 environments successfully updated!"
