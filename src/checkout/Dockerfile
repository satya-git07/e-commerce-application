# Use golang image to build the project
FROM golang:1.22-alpine AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app/

# Mount the cache for Go modules and bind the go.mod and go.sum files from the parent directory
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=../go.sum,target=go.sum \
    --mount=type=bind,source=../go.mod,target=go.mod \
    go mod download

# Now build the project using the go source code from the parent directory
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,rw,source=../,target=. \
    go build -ldflags "-s -w" -o /go/bin/checkout/ ./

# Final image (alpine) to run the checkout service
FROM alpine

# Set the working directory inside the container
WORKDIR /usr/src/app/

# Copy the built binary from the builder stage
COPY --from=builder /go/bin/checkout/ ./

# Expose the required port for the service
EXPOSE ${CHECKOUT_PORT}

# Define the entrypoint for the container
ENTRYPOINT [ "./checkout" ]

