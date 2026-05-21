# Deployment Guide

This guide is for deploying the Binge Watch Online static website using the files in this repository.

## 1. Prepare the website files

The files that need to be uploaded are inside the `website/` folder:

```text
index.html
styles.css
script.js
thankyou.html
```

Before uploading, open `website/index.html` locally and check that the page loads correctly.

## 2. Create the S3 bucket

The bucket is created by the CloudFormation template. First copy the config file:

```powershell
Copy-Item .\deployment\config.example.json .\deployment\config.json
```

Edit `deployment/config.json` and add unique bucket names. Then run:

```powershell
.\deployment\scripts\deploy-stack.ps1
```

## 3. Create CloudFront distribution

The CloudFront distribution is also created by the template. After deployment, AWS gives a domain name like:

```text
dxxxxxxxxxxxxx.cloudfront.net
```

Open this URL and check if the website loads.

## 4. Update files later

Upload website files with:

```powershell
.\deployment\scripts\sync-website.ps1
```

If CloudFront is still showing the old page, use:

```powershell
.\deployment\scripts\sync-website.ps1 -Invalidate
```

## 5. Configure Route 53

If a hosted zone and certificate are added in the config file, the template creates the Route 53 alias record.

For this project, Route 53 is mainly used to route the domain to CloudFront. If there are multiple website endpoints later, latency based routing can be used to send users to the better endpoint based on location.

## 6. Launch EC2 VM

The EC2 VM is optional. Set `CreateEc2` to `true` in the config if a VM is needed for testing and admin work.

For example:

- Amazon Linux 2023
- Small instance type for lab work
- Security group with SSH only from my IP

The EC2 instance is not needed to serve the static pages because S3 and CloudFront are doing that job.

## 7. Connect EC2 with S3

The template attaches an IAM role to the EC2 instance. The role allows S3 access for the website bucket and team sharing bucket.

Example tasks from EC2:

```bash
aws s3 ls
aws s3 ls s3://binge-watch-online-site/
aws s3 cp test-file.txt s3://binge-watch-team-share/
```

This proves the VM can connect with the storage service.

## 8. Team sharing bucket

The template creates another S3 bucket for teammate files, for example:

```text
binge-watch-team-share
```

This bucket can store shared screenshots, notes, reports, or deployment files. It is private by default. Teammates can get access through IAM users, IAM Identity Center, or pre-signed URLs if the file only needs to be shared for a short time.

## 9. Quick testing checklist

- S3 bucket contains the website files
- CloudFront URL opens `index.html`
- CSS and JavaScript load correctly
- `thankyou.html` opens after form submit
- Route 53 domain points to CloudFront
- EC2 can run `aws s3 ls`
- Billing budget alert is enabled

## Notes

For this assignment, I am keeping the deployment simple. I am not using Kubernetes, Terraform, or a CI/CD pipeline because the site is only static and the requirement is mainly about AWS hosting and CDN delivery.
