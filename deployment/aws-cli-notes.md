# AWS CLI Notes

These commands are examples for deployment. The bucket names need to be changed if they are already taken.

## Upload website files to S3

```bash
aws s3 sync ./website s3://binge-watch-online-site
```

## Check uploaded files

```bash
aws s3 ls s3://binge-watch-online-site/
```

## Upload a file to team sharing bucket

```bash
aws s3 cp ./project-notes.txt s3://binge-watch-team-share/
```

## Download a shared file on EC2

```bash
aws s3 cp s3://binge-watch-team-share/project-notes.txt .
```

## CloudFront invalidation after website update

```bash
aws cloudfront create-invalidation \
  --distribution-id YOUR_DISTRIBUTION_ID \
  --paths "/*"
```

## Route 53

I would usually configure Route 53 from the AWS console for this project because it is easier to show in screenshots. The final record should be an alias A record pointing to the CloudFront distribution.
