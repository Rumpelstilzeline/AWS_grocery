# variables.tf ergänzen wir um bucket_name (s.u.)
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name   # weltweit eindeutig, z.B. "grocerymate-<dein-uniq-suffix>"
}

# Standard: Public Access blocken
resource "aws_s3_bucket_public_access_block" "app_bucket_block" {
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Serverseitige Verschlüsselung (SSE-S3), kostenlos & empfehlenswert
resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_sse" {
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional: Versionierung (abschaltbar, spart Speicher)
resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Suspended" # "Enabled" wenn gewünscht
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

