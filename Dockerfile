FROM rust:1.70-slim AS builder
RUN apt-get update && apt-get install -y git pkg-config libssl-dev build-essential && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/v3ctr4x/HashCrack .
RUN cargo build --release

FROM alpine:3.19
RUN apk add --no-cache bash libgcc openssl gcompat musl-dev

RUN mkdir -p /app

COPY --from=builder /app/target/release/HashCrack /app/HashCrack
RUN chmod +x /app/HashCrack

WORKDIR /app
ENTRYPOINT ["./HashCrack"]

