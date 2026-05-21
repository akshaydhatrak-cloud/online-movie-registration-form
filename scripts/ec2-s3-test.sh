#!/usr/bin/env bash
set -e

WEBSITE_BUCKET="$1"
TEAM_BUCKET="$2"

if [ -z "$WEBSITE_BUCKET" ] || [ -z "$TEAM_BUCKET" ]; then
  echo "Usage: ./infrastructure/scripts/ec2-s3-test.sh <website-bucket-name> <team-share-bucket-name>"
  exit 1
fi

aws s3 ls "s3://$WEBSITE_BUCKET/"
echo "EC2 can upload to S3" > ec2-test-file.txt
aws s3 cp ec2-test-file.txt "s3://$TEAM_BUCKET/ec2-test-file.txt"
aws s3 cp "s3://$TEAM_BUCKET/ec2-test-file.txt" downloaded-ec2-test-file.txt
