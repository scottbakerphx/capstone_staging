# Stage 1: Build the Go binary using Go 1.26
FROM golang:1.26-alpine AS builder

WORKDIR /app

# Copy dependency files and download modules
COPY go.mod ./
RUN go mod download

# Copy source code and build binary
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o server .

# Stage 2: Minimal runtime container
FROM alpine:3.19

RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=builder /app/server .

EXPOSE 8080

CMD ["./server"]
