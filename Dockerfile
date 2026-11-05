# syntax=docker/dockerfile:1
# Multi-stage build: download the official xray-core release binary
# into a small Alpine image. The entrypoint generates the config from
# UUID / WS_PATH / PORT environment variables at container start.
FROM alpine:latest AS builder
RUN apk add --no-cache curl unzip ca-certificates
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && unzip /tmp/xray.zip -d /tmp/xray && chmod +x /tmp/xray/xray

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /tmp/xray/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
