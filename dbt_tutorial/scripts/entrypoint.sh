#!/bin/bash
set -e

# Dev note: Experimenting with emojis to look cleaner while building
echo "🔐 Decoding GCP service account key..."
echo "$GCP_KEY_BASE64" | base64 -d > "$GCP_KEY_OUTPUT"

echo "📦 Installing dbt packages..."
dbt deps

echo "🔍 Debugging connection..."
dbt debug

echo "🌱 Seeding data..."
dbt seed

echo "🚀 Running dbt models..."
dbt run

echo "✅ Done!"
exec "$@"


