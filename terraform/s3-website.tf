resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = data.aws_s3_bucket.root-bucket.id
  index_document {
    suffix = "${var.index_document}"
  }
  error_document {
    key = "${var.error_document}"
  }
}