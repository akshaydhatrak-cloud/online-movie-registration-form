#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="${1:-}"
DISTRIBUTION_ID="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -z "$BUCKET_NAME" ]; then
  echo "Usage: ./scripts/sync-website.sh <website-bucket-name> [cloudfront-distribution-id]"
  exit 1
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "AWS CLI is not installed or not available in PATH."
  exit 1
fi

aws s3 sync "$PROJECT_ROOT/src/" "s3://$BUCKET_NAME/"

if [ -n "$DISTRIBUTION_ID" ]; then
  aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
fi
