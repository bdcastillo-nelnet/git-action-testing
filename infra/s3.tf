resource "aws_s3_bucket" "david_website_bucket" {
  bucket = "david-website-bucket"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.david_website_bucket.id
  acl    = "private"

  key          = "index.html"
  source       = "../web/index.html"
  content_type = "text/html; charset=utf-8"

  etag = filemd5("../web/index.html")
}