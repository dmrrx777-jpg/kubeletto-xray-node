#!/bin/sh
set -e
# NOTE: Kubeletto's env-var API currently returns "failed to set env var"
# for every variable (even TEST=hello), so the required values are
# baked in here as defaults. If the platform later injects UUID /
# WS_PATH / PORT, those values take precedence over these defaults.
PORT=${PORT:-8080}
UUID=${UUID:-2e7fc655-58ab-4041-9aa9-114623d128db}
WS_PATH=${WS_PATH:-/f596dd1178a510e9}
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}", "flow": ""}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [
    {"protocol": "freedom", "tag": "direct"},
    {"protocol": "blackhole", "tag": "blocked"}
  ]
}
EOF
exec /usr/local/bin/xray run -c /etc/xray/config.json
