resource "random_string" "bucket_postfix" {
  length  = 4
  special = false
  upper = false
}

resource "aws_s3_bucket" "bucket-root" {
  bucket = "root.${var.bucket_name}.${random_string.bucket_postfix.result}"
  force_destroy = true
  depends_on = [ random_string.bucket_postfix ]
}

data "aws_s3_bucket" "root-bucket" {
  bucket = aws_s3_bucket.bucket-root.bucket
}

resource "aws_s3_bucket" "bucket-log" {
  bucket = "log.${var.bucket_name}-${random_string.bucket_postfix.result}"
  force_destroy = true
  depends_on = [ random_string.bucket_postfix ]
}

data "aws_s3_bucket" "log-bucket" {
  bucket = aws_s3_bucket.bucket-log.bucket
}