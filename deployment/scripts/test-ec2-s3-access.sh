#!/usr/bin/env bash
set -e

WEBSITE_BUCKET="$1"
TEAM_BUCKET="$2"

if [ -z "$WEBSITE_BUCKET" ] || [ -z "$TEAM_BUCKET" ]; then
  echo "Usage: ./test-ec2-s3-access.sh <website-bucket> <team-share-bucket>"
  exit 1
fi

aws s3 ls "s3://$WEBSITE_BUCKET/"
echo "EC2 test file created on $(date)" > ec2-storage-test.txt
aws s3 cp ec2-storage-test.txt "s3://$TEAM_BUCKET/ec2-storage-test.txt"
aws s3 ls "s3://$TEAM_BUCKET/ec2-storage-test.txt"
