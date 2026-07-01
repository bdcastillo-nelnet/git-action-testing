resource "aws_cloudfront_origin_access_control" "david_website_oac" {
  name                              = "david-website-oac"
  description                       = "OAC for David's website"
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
  origin_access_control_origin_type = "s3"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "david_website_bucket_policy" {
  bucket = aws_s3_bucket.david_website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.david_website_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn"     = aws_cloudfront_distribution.david_website_distribution.arn
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}