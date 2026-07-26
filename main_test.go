package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func TestHealthHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/health", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(healthHandler)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	var resp HealthResponse
	if err := json.NewDecoder(rr.Body).Decode(&resp); err != nil {
		t.Fatalf("failed to decode response: %v", err)
	}

	if resp.Status != "healthy" {
		t.Errorf("expected status 'healthy', got '%v'", resp.Status)
	}
}

func TestMetricsHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/metrics", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(metricsHandler)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	var resp MetricResponse
	if err := json.NewDecoder(rr.Body).Decode(&resp); err != nil {
		t.Fatalf("failed to decode response: %v", err)
	}

	if resp.Status != "operational" {
		t.Errorf("expected status 'operational', got '%v'", resp.Status)
	}
}

func TestSetupServer_DefaultPort(t *testing.T) {
	os.Unsetenv("PORT")
	server, safePort := setupServer()

	if safePort != "8080" {
		t.Errorf("expected default port 8080, got %s", safePort)
	}
	if server.Addr != ":8080" {
		t.Errorf("expected server address :8080, got %s", server.Addr)
	}
}

func TestSetupServer_CustomPort(t *testing.T) {
	os.Setenv("PORT", "9090")
	defer os.Unsetenv("PORT")

	server, safePort := setupServer()

	if safePort != "9090" {
		t.Errorf("expected custom port 9090, got %s", safePort)
	}
	if server.Addr != ":9090" {
		t.Errorf("expected server address :9090, got %s", server.Addr)
	}
}

func TestSetupServer_InvalidPort(t *testing.T) {
	os.Setenv("PORT", "invalid")
	defer os.Unsetenv("PORT")

	server, safePort := setupServer()

	if safePort != "8080" {
		t.Errorf("expected fallback port 8080 for invalid PORT env, got %s", safePort)
	}
	if server.Addr != ":8080" {
		t.Errorf("expected server address :8080, got %s", server.Addr)
	}
}
