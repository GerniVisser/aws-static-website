
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = data.aws_s3_bucket.root-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = data.aws_s3_bucket.root-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "log_acl" {
  bucket = data.aws_s3_bucket.log-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "origin" {
  depends_on = [
    aws_cloudfront_distribution.static_website_distribution,
    aws_s3_bucket.bucket-root
  ]
  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket-root.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.static_website_distribution.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "origin" {
  depends_on = [
    aws_cloudfront_distribution.static_website_distribution
  ]
  bucket = aws_s3_bucket.bucket-root.id
  policy = data.aws_iam_policy_document.origin.json
}

data "aws_iam_policy_document" "logs_policy" {
  depends_on = [
    aws_cloudfront_distribution.static_website_distribution,
    aws_s3_bucket.bucket-root
  ]
  statement {
    sid    = "4"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket-log.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.static_website_distribution.arn
      ]
    }
  }
}
