provider "aws" {
  region = "ap-south-1"
}

# Create the bucket
resource "aws_s3_bucket" "website" {
  bucket = "chandan-terraform-html-site-ap-south-1"
}

# Configure the bucket as a static website
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Upload the index.html file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Make the bucket publicly accessible via a policy
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# Output the website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
