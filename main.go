package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

type HealthResponse struct {
	Status    string    `json:"status"`
	Service   string    `json:"service"`
	Timestamp time.Time `json:"timestamp"`
	Uptime    string    `json:"uptime"`
}

type MetricResponse struct {
	Goroutines  int    `json:"goroutines"`
	MemoryAlloc string `json:"memory_alloc"`
	Status      string `json:"status"`
}

var startTime time.Time

func init() {
	startTime = time.Now()
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	resp := HealthResponse{
		Status:    "healthy",
		Service:   "go-platform-gateway",
		Timestamp: time.Now(),
		Uptime:    time.Since(startTime).String(),
	}
	
	if err := json.NewEncoder(w).Encode(resp); err != nil {
		log.Printf("failed to encode health response: %v", err)
	}
}

func metricsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	resp := MetricResponse{
		Goroutines:  1,
		MemoryAlloc: "minimal",
		Status:      "operational",
	}
	
	if err := json.NewEncoder(w).Encode(resp); err != nil {
		log.Printf("failed to encode metrics response: %v", err)
	}
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Sanitize port input to prevent G706 log injection
	portInt, err := strconv.Atoi(port)
	if err != nil {
		log.Printf("Invalid PORT environment variable, defaulting to 8080")
		portInt = 8080
	}
	safePort := strconv.Itoa(portInt)

	mux := http.NewServeMux()
	mux.HandleFunc("/health", healthHandler)
	mux.HandleFunc("/metrics", metricsHandler)

	log.Printf("🚀 Go Gateway starting on port %s...", safePort)

	// Configure server with explicit timeouts to prevent G114
	server := &http.Server{
		Addr:              fmt.Sprintf(":%s", safePort),
		Handler:           mux,
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      15 * time.Second,
		IdleTimeout:       60 * time.Second,
	}

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("Server failed to start: %v", err)
	}
}
