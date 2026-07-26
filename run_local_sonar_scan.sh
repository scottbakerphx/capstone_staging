#!/usr/bin/env bash
set -e

SONAR_TOKEN="sqa_fb95fcef72c7a8904282f9c01b35c5c653598936"
SONAR_HOST_URL="https://configuration-somebody-chrome-outsourcing.trycloudflare.com"

echo "1. Running Go tests and collecting coverage..."
go test -v -coverprofile=coverage.out ./...

echo "2. Sending analysis to SonarQube via Cloudflare Tunnel..."
docker run --rm \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli \
  -Dsonar.host.url="$SONAR_HOST_URL" \
  -Dsonar.token="$SONAR_TOKEN" \
  -Dsonar.projectKey="go-gateway" \
  -Dsonar.projectName="Go Microservice Gateway" \
  -Dsonar.sources="." \
  -Dsonar.exclusions="**/*_test.go,**/vendor/**" \
  -Dsonar.tests="." \
  -Dsonar.test.inclusions="**/*_test.go" \
  -Dsonar.go.coverage.reportPaths="coverage.out"

echo ""
echo "Scan complete! View your project report here:"
echo "http://localhost:9008/dashboard?id=go-gateway"
