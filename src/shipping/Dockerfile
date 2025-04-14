FROM debian:bookworm-slim

WORKDIR /app

# Copy the prebuilt binary
COPY target/debug/shipping /app/shipping

# Add gRPC health probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.24
RUN apt-get update && apt-get install -y wget ca-certificates && \
    wget -qO /bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

# Set fixed port here
ENV SHIPPING_PORT=50052

# Expose it
EXPOSE 50052

ENTRYPOINT ["/app/shipping"]

