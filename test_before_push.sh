#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Step 1: Running unit tests..."
go test -v -cover ./...

echo "🐳 Step 2: Building container..."
docker build -t go-gateway:test .

echo "🚀 Step 3: Spinning up ephemeral container on port 8081..."
CONTAINER_ID=$(docker run -d -p 8081:8080 go-gateway:test)

# Auto-cleanup container on script exit
trap 'echo "🧹 Cleaning up test container..."; docker stop "$CONTAINER_ID" >/dev/null; docker rm "$CONTAINER_ID" >/dev/null' EXIT

sleep 2

echo "🧪 Step 4: Testing HTTP endpoints..."

HEALTH_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/health)
if [ "$HEALTH_STATUS" -ne 200 ]; then
    echo "❌ /health check failed with status $HEALTH_STATUS"
    exit 1
fi
echo "  ✓ /health returned 200 OK"

METRICS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/metrics)
if [ "$METRICS_STATUS" -ne 200 ]; then
    echo "❌ /metrics check failed with status $METRICS_STATUS"
    exit 1
fi
echo "  ✓ /metrics returned 200 OK"

echo "✅ All pre-push checks passed cleanly!"
