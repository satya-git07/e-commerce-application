# Stage 1: Build
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
ARG TARGETARCH

WORKDIR /usr/src/app/
COPY . ./

RUN dotnet restore ./cart.csproj -r linux-musl-$TARGETARCH
RUN dotnet publish ./cart.csproj -r linux-musl-$TARGETARCH --no-restore -o /cart

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine3.20

WORKDIR /usr/src/app/
COPY --from=builder /cart/ ./

ENV DOTNET_HOSTBUILDER__RELOADCONFIGONCHANGE=false

EXPOSE ${CART_PORT}
ENTRYPOINT ["./cart"]

