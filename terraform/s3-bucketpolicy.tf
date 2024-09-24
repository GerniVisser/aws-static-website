
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = data.aws_s3_bucket.root-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = data.aws_s3_bucket.root-bucket.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "log_acl" {
  bucket = data.aws_s3_bucket.log-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
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

  statement {
    sid    = "GitHubActionsWriteAccess"
    effect = "Allow"
    
    # Allow these actions to upload/write objects
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    
    # Replace with your IAM user's ARN
    principals {
      identifiers = ["arn:aws:iam::653956157426:user/Github_upload_s3"]
      type        = "AWS"
    }
    
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket-root.bucket}/*"
    ]
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

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "logs_policy" {
  depends_on = [
    aws_cloudfront_distribution.static_website_distribution
  ]
  bucket = aws_s3_bucket.bucket-log.id
  policy = data.aws_iam_policy_document.logs_policy.json
}
