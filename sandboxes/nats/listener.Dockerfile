# Use the official Rust image as the base image for building
FROM rust:1.89 as builder

# Set the working directory
WORKDIR /app

COPY . .

RUN cargo build --release --bin listener

# Use a smaller base image for the final runtime
FROM debian:bookworm-slim

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/target/release/listener /app/listener

# Set the default command
CMD ["./listener"]
