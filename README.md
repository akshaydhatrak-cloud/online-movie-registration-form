# AWS Global Website Deployment - Binge Watch Online

## Overview

This project deploys a static entertainment website for Binge Watch Online using AWS storage, CDN, and DNS services. The website stays as a static HTML application in `src/`; EC2 is only used as a support VM for AWS CLI testing and S3 access checks.

## Architecture

The public traffic path is:

```text
User -> Route 53 -> CloudFront -> S3 website bucket
```

The operations path is separate:

```text
EC2 support VM -> AWS CLI -> S3 website bucket
EC2 support VM -> AWS CLI -> S3 team share bucket
```

Architecture files are in `architecture/`:

- `architecture.mmd`
- `architecture.svg`
- `architecture.drawio`

## Services Used

- Amazon S3 for static website files and team file sharing
- Amazon CloudFront for CDN caching
- Amazon Route 53 for DNS routing
- Amazon EC2 for support/testing access
- IAM for scoped S3 permissions

## Deployment Steps

1. Create an S3 bucket for the static website files.
2. Upload the files from `src/` to the bucket.
3. Create a CloudFront distribution with the S3 bucket as the origin.
4. Set `index.html` as the CloudFront default root object.
5. Configure Route 53 with an alias record pointing to CloudFront.
6. Create a second S3 bucket for team file sharing.
7. Launch a small EC2 instance and attach IAM access for the required S3 buckets.
8. Run the S3 validation script from the EC2 instance.

Upload the site:

```bash
./scripts/upload-website.sh binge-watch-online-site
```

Sync updates and optionally invalidate CloudFront:

```bash
./scripts/sync-website.sh binge-watch-online-site E1234567890ABC
```

Test EC2 access to S3:

```bash
./scripts/ec2-s3-test.sh binge-watch-online-site binge-watch-team-share
```

## Troubleshooting

- If the CloudFront URL shows an older page, run the sync script with the distribution ID so it creates an invalidation.
- If `aws s3 ls` fails from EC2, check the IAM role or AWS CLI credentials.
- If the website loads without the thank you page, confirm both `index.html` and `thankyou.html` are in the S3 bucket.
- If Route 53 does not resolve, check the alias target and wait for DNS propagation.

## What I Learned

- Static websites do not need EC2 as the public hosting layer.
- CloudFront is useful when static assets are requested from different locations.
- S3 buckets should be separated by purpose: public website origin and private team sharing.
- Small helper scripts make repeat uploads less error-prone.
