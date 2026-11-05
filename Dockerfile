# syntax=docker/dockerfile:1
# Multi-stage build: copy the xray binary from the official xray-core image
# into a small Alpine image. The entrypoint generates the config from
# UUID / WS_PATH / PORT environment variables at container start.
FROM ghcr.io/xtls/xray-core:latest AS xray

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
