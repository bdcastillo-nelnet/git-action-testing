resource "aws_cloudfront_distribution" "david_website_distribution" {
    origin {

        domain_name = aws_s3_bucket.david_website_bucket.bucket_regional_domain_name
        origin_id   = "david-website-bucket"
        origin_access_control_id = aws_cloudfront_origin_access_control.david_website_oac.id
    }

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "CloudFront distribution for David's website"
    default_root_object = "index.html"
    
    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "david-website-bucket"

        forwarded_values {
        query_string = false

            cookies {
                forward = "none"
            }
        }


        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0 
        default_ttl            = 3600 
        max_ttl                = 86400 
    }
    
    price_class = "PriceClass_100"
    
    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }
    
    viewer_certificate {
        cloudfront_default_certificate = true
    }
    }