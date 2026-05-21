#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -z "$BUCKET_NAME" ]; then
  echo "Usage: ./scripts/upload-website.sh <website-bucket-name>"
  exit 1
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "AWS CLI is not installed or not available in PATH."
  exit 1
fi

aws s3 cp "$PROJECT_ROOT/src/" "s3://$BUCKET_NAME/" --recursive
