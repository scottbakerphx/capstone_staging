# Stage 1: Build the Go binary using Go 1.26
FROM golang:1.26-alpine AS builder

WORKDIR /app

# Copy dependency files and download modules
COPY go.mod ./
RUN go mod download

# Copy Go source files explicitly to avoid recursive copy warnings
COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o server .

# Stage 2: Minimal runtime container
FROM alpine:3.19

RUN apk --no-cache add ca-certificates

# Create a non-root user and group for security compliance
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy binary from builder stage and set ownership to appuser
COPY --from=builder /app/server .
RUN chown appuser:appgroup /app/server

# Switch to non-root user
USER appuser

EXPOSE 8080
CMD ["./server"]
