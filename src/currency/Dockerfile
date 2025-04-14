FROM alpine:3.18 AS builder

#ARG OPENTELEMETRY_CPP_VERSION=1.11.0
ARG OPENTELEMETRY_CPP_VERSION=1.14.0

RUN apk update && apk add git cmake make g++ grpc-dev protobuf-dev linux-headers

# Build OpenTelemetry C++ SDK
RUN git clone --depth 1 --branch v${OPENTELEMETRY_CPP_VERSION} https://github.com/open-telemetry/opentelemetry-cpp \
    && cd opentelemetry-cpp/ && mkdir build && cd build \
    && cmake .. -DCMAKE_CXX_STANDARD=17 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
          -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF \
          -DWITH_EXAMPLES=OFF -DWITH_OTLP_GRPC=ON -DWITH_ABSEIL=ON \
    && make -j$(nproc || sysctl -n hw.ncpu || echo 1) install

# Copy currency source and proto
COPY . /currency
COPY ./pb/demo.proto /currency/proto/demo.proto

WORKDIR /currency/build
RUN cmake .. && make -j$(nproc || sysctl -n hw.ncpu || echo 1) install


FROM alpine:3.18 AS release

RUN apk update && apk add grpc-dev protobuf-dev

COPY --from=builder /usr/local /usr/local

EXPOSE 8080
ENV CURRENCY_PORT=8080
ENTRYPOINT ["/usr/local/bin/currency"]


#ENTRYPOINT sh -c "/usr/local/bin/currency ${CURRENCY_PORT}"

