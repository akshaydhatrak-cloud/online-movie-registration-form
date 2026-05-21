# Deployment Guide

This guide captures the deployment flow used for the static website.

## 1. S3 website bucket

Create an S3 bucket for the website files. Keep the name simple and unique, for example:

```text
binge-watch-online-site
```

Upload the files from the `src/` folder:

```bash
aws s3 cp src/ s3://binge-watch-online-site/ --recursive
```

## 2. CloudFront

Create a CloudFront distribution.

Use the S3 bucket as the origin. Set the default root object to:

```text
index.html
```

After CloudFront is created, open the CloudFront domain name and check that the registration page loads.

## 3. Route 53

In Route 53, create or use a hosted zone for the website domain.

Create an alias record that points to the CloudFront distribution. This lets users open the website through the normal domain name instead of the CloudFront URL.

## 4. Updating files

When the website changes, sync the source folder again:

```bash
aws s3 sync src/ s3://binge-watch-online-site/
```

If CloudFront still shows the older page, create an invalidation:

```bash
aws cloudfront create-invalidation --distribution-id DISTRIBUTION_ID --paths "/*"
```

## 5. EC2 support VM

Launch a small Windows or Linux EC2 instance for testing. Install or configure AWS CLI on it.

The EC2 instance should use an IAM role or IAM user credentials with limited S3 permissions. It should not host the public website.

From EC2, test:

```bash
aws s3 ls
aws s3 ls s3://binge-watch-online-site/
```
