# Use the official Rust image as the base image for building
FROM rust:1.89 as builder

# Set the working directory
WORKDIR /app

# Copy the Cargo.toml and Cargo.lock files first to leverage Docker layer caching
COPY . .

# Build dependencies (this will be cached if Cargo.toml doesn't change)
RUN cargo build --release --bin server

# Use a smaller base image for the final runtime
FROM debian:bookworm-slim

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/target/release/server /app/server

# Expose the port that the server runs on
EXPOSE 3000

# Set the default command
CMD ["./server"]
