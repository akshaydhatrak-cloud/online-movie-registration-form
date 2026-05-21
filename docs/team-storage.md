# Team Storage

The project also needs storage for teammates to share files. A second S3 bucket is used for that purpose.

Example bucket:

```text
binge-watch-team-share
```

This bucket is separate from the website bucket. That keeps website files away from project notes or shared documents.

Example commands from EC2:

```bash
aws s3 cp notes.txt s3://binge-watch-team-share/
aws s3 cp s3://binge-watch-team-share/notes.txt .
```

Access should be controlled with IAM. A teammate who only needs to upload files should not get full admin access.
