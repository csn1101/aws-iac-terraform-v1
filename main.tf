provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "chandan-terraform-html-site-ap-south-1"   # must be globally unique
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

output "website_url" {
  value = aws_s3_bucket.website.website_endpoint
}
