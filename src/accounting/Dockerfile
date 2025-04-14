# Stage 1: Build
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:8.0 AS builder
ARG TARGETARCH
ARG BUILD_CONFIGURATION=Release

# Set working directory in container
WORKDIR /src/app

# Copy all project files
COPY . .
# Create the proto folder and copy proto file
RUN mkdir -p proto
COPY ./pb/demo.proto ./proto/demo.proto

# Restore dependencies
RUN dotnet restore "Accounting.csproj" -r linux-$TARGETARCH

# Build the app
RUN dotnet build "Accounting.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Stage 2: Publish
FROM builder AS publish
ARG TARGETARCH
ARG BUILD_CONFIGURATION=Release

RUN dotnet publish "Accounting.csproj" -r linux-$TARGETARCH -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Stage 3: Final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Use non-root user for security
USER app
WORKDIR /app

# Copy published output from previous stage
COPY --from=publish /app/publish .

# Switch to root briefly for permissions (if needed)
USER root
RUN mkdir -p "/var/log/opentelemetry/dotnet"
RUN chown app "/var/log/opentelemetry/dotnet"
RUN chown app "/app/instrument.sh" || true

# Switch back to app user
USER app

# Set entrypoint
ENTRYPOINT ["./instrument.sh", "dotnet", "Accounting.dll"]

