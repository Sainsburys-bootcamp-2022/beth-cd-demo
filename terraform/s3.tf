# Create the bucket itself
resource "aws_s3_bucket" "website_bucket" {
  bucket_prefix = "${lower(var.owner_name)}-website-bucket"

  tags = {
    classification: "public"
    retention: "1d"
  }
}

# List files in the build directory
module "website_files" {
  source = "hashicorp/dir/template"

  base_dir = "../beth-site/build"
}

# Upload site files to the bucket
resource "aws_s3_object" "website_bucket" {
  for_each = module.website_files.files

  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = each.key
  source       = each.value.source_path
  etag         = each.value.digests.md5
  content_type = each.value.content_type
}

# Create a resource policy allowing public read access
data "aws_iam_policy_document" "public_read" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = data.aws_iam_policy_document.public_read.json
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}
