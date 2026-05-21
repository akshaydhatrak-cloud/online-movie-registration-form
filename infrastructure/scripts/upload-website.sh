#!/usr/bin/env bash
set -e

BUCKET_NAME="$1"

if [ -z "$BUCKET_NAME" ]; then
  echo "Usage: ./infrastructure/scripts/upload-website.sh <website-bucket-name>"
  exit 1
fi

aws s3 cp src/ "s3://$BUCKET_NAME/" --recursive
