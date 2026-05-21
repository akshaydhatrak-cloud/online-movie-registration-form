#!/usr/bin/env bash
set -e

BUCKET_NAME="$1"
DISTRIBUTION_ID="$2"

if [ -z "$BUCKET_NAME" ]; then
  echo "Usage: ./infrastructure/scripts/sync-website.sh <website-bucket-name> [cloudfront-distribution-id]"
  exit 1
fi

aws s3 sync src/ "s3://$BUCKET_NAME/"

if [ -n "$DISTRIBUTION_ID" ]; then
  aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
fi
