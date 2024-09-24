resource "aws_s3_object" "object-upload-all" {
  for_each = fileset("${var.html_source_dir}/", "*")
  bucket   = data.aws_s3_bucket.root-bucket.id
  key      = each.value
  source   = "${var.html_source_dir}/${each.value}"
  etag     = filemd5("${var.html_source_dir}/${each.value}")
  content_type = "text/html"
}