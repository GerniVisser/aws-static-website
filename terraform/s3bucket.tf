resource "aws_s3_bucket" "bucket-root" {
  bucket = "root.${var.bucket_name}"
  force_destroy = true
}

data "aws_s3_bucket" "root-bucket" {
  bucket = aws_s3_bucket.bucket-root.bucket
}

resource "aws_s3_bucket" "bucket-log" {
  bucket = "log.${var.bucket_name}"
  force_destroy = true
}

data "aws_s3_bucket" "log-bucket" {
  bucket = aws_s3_bucket.bucket-log.bucket
}