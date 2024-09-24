variable "domain_name" {
  type        = string
  description = "Name of the domain"
}
variable "bucket_name" {
  type        = string
  description = "Name of the bucket."
}
variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "index_document" {
  description = "The index document of the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document of the website"
  type        = string
  default     = "404.html"
}

variable "html_source_dir" {
  description = "Directory path for HTML source files"
  type        = string
  default     = "../website"
}

variable "access_key" {
  type    = string
}
variable "secret_key" {
  type    = string
}