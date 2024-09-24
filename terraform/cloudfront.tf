resource "aws_cloudfront_origin_access_control" "Site_Access" {
  name                              = "Security_Pillar100_CF_S3_OAC"
  description                       = "OAC setup for security pillar 100"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_website_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.root-bucket.bucket_regional_domain_name
    origin_id   = data.aws_s3_bucket.root-bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.Site_Access.id
  }

  enabled = true
  default_root_object = var.index_document

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = data.aws_s3_bucket.root-bucket.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      headers = ["Content-Type", "Origin", "Accept"]
      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  # logging_config {
  #   bucket = data.aws_s3_bucket.log-bucket.bucket_regional_domain_name
  #   include_cookies = false
  #   prefix = "cloudfront-logs"
  # }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # viewer_certificate {
  #   acm_certificate_arn      = aws_acm_certificate.cert.arn
  #   ssl_support_method       = "sni-only"
  #   minimum_protocol_version = "TLSv1.2_2021" 
  # }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }
}

resource "null_resource" "invalidate_html" {
  triggers = {
    index_file_hash = filemd5("${var.html_source_dir}/${var.index_document}")
    error_file_hash = filemd5("${var.html_source_dir}/${var.error_document}")
  }

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.static_website_distribution.id} --paths /index.html /404.html"

    environment = {
      AWS_ACCESS_KEY_ID     = var.access_key
      AWS_SECRET_ACCESS_KEY = var.secret_key
      AWS_DEFAULT_REGION    = var.region
    }
  }

  depends_on = [aws_cloudfront_distribution.static_website_distribution]
}