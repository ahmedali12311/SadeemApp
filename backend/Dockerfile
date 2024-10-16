# Use the official Golang image as a build stage
FROM golang:1.22.3 AS builder

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum files for better caching
COPY go.mod go.sum ./

# Download dependencies

# Copy the entire project to the /app directory
COPY . .

# Change to the cmd/api directory before building
WORKDIR /app/cmd/api
ENV PORT 8080
ENV DATABASE_URL postgres://postgres:091093Aa@localhost:5432/internship?sslmode=disable

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Use a minimal base image for the final executable
FROM gcr.io/distroless/base

# Set the working directory
WORKDIR /app
VOLUME /app/cmd/api/images

# Copy the compiled binary from the builder stage
COPY --from=builder /app/cmd/api/main .

# Copy the .env file from the builder stage
COPY --from=builder /app/cmd/api/.env .
COPY .env /app/.env

# Copy the certs directory from the current directory
COPY certs /certs

# Expose the port your app listens on
EXPOSE 8080

# Command to run the executable
CMD ["./main"]