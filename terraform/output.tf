output "s3_bucket_url" {
  description = "The website URL of the S3 bucket"
  value       = "http://${data.aws_s3_bucket.root-bucket.bucket}.s3-website.${var.region}.amazonaws.com"
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket hosting the website"
  value       = data.aws_s3_bucket.root-bucket.bucket_domain_name
}


output "cloudfront_distribution_domain" {
  value = aws_cloudfront_distribution.static_website_distribution.domain_name
}