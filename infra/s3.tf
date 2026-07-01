resource "aws_s3_bucket" "david_website_bucket" {
  bucket = "david-website-bucket"
}

# Website file contents are deployed via `aws s3 sync web/dist/ ...`,
# not managed here, so Terraform state stays clean of build artifacts.