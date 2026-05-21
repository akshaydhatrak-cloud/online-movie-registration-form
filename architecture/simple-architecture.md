# Simple Architecture Diagram

```text
+------------------+
| Website Visitor  |
+--------+---------+
         |
         v
+------------------+
| Route 53 DNS     |
+--------+---------+
         |
         v
+------------------+
| CloudFront CDN   |
+--------+---------+
         |
         v
+------------------+
| S3 Website Bucket|
+------------------+

+------------------+        +----------------------+
| EC2 VM           | -----> | S3 Team Share Bucket |
+------------------+        +----------------------+
```

The first flow is for public website visitors. The second flow is for project/team file sharing and testing from the VM.
