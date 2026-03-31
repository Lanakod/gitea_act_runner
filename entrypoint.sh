#!/bin/bash
set -e

# Пути
DATA_DIR="/data"
CONFIG_FILE="$DATA_DIR/config.yaml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚙️  Config file not found. Generating config via act_runner generate-config..."

    act_runner generate-config > "$CONFIG_FILE"

    echo "✅ config.yaml generated at $CONFIG_FILE"
fi

if [ ! -f "$DATA_DIR/.runner" ]; then
    echo "🔧 Runner not registered. Registering with instance: $GITEA_INSTANCE_URL"
    act_runner \
        --config "$CONFIG_FILE" \
        register \
        --no-interactive \
        --instance "${GITEA_INSTANCE_URL}" \
        --token "${GITEA_RUNNER_REGISTRATION_TOKEN}" \
        --labels "${GITEA_RUNNER_LABELS}" \
        --name "${GITEA_RUNNER_NAME}"
else
    echo "✅ Runner already registered. Skipping registration."
fi

echo "🚀 Starting runner daemon..."
exec act_runner daemon --config "$CONFIG_FILE"