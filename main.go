package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
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
	json.NewEncoder(w).Encode(resp)
}

func metricsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	resp := MetricResponse{
		Goroutines:  1,
		MemoryAlloc: "minimal",
		Status:      "operational",
	}
	json.NewEncoder(w).Encode(resp)
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/health", healthHandler)
	mux.HandleFunc("/metrics", metricsHandler)

	log.Printf("🚀 Go Gateway starting on port %s...", port)
	if err := http.ListenAndServe(fmt.Sprintf(":%s", port), mux); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
