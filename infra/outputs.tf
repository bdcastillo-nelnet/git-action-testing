output "cloudfront_domain_name" {
  description = "The CloudFront distribution domain name to use in a browser."
  value       = aws_cloudfront_distribution.david_website_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront hosted zone ID for DNS records."
  value       = aws_cloudfront_distribution.david_website_distribution.hosted_zone_id
}

output "s3_bucket_regional_domain_name" {
  description = "The regional S3 bucket domain name used by CloudFront origin."
  value       = aws_s3_bucket.david_website_bucket.bucket_regional_domain_name
}

output "pull_users_url" {
  description = "Public Function URL for listing users. Put this in web/.env as VITE_USERS_API_URL."
  value       = aws_lambda_function_url.pull_users.function_url
}

output "create_user_url" {
  description = "Public Function URL for creating a user. Put this in web/.env as VITE_CREATE_USER_API_URL."
  value       = aws_lambda_function_url.create_user.function_url
}
