resource "aws_s3_bucket_ownership_controls" "s3_ownership_control" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_accelerate_configuration" "s3_bucket_accelerate_config" {
  count  = var.acceleration_status == null ? 0 : 1
  bucket = aws_s3_bucket.s3_bucket.id
  status = var.acceleration_status
}

resource "aws_s3_bucket_versioning" "bucket_version_config" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = local.versioning
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count  = var.bucket_policy != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_enc_config" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors_config" {
  count  = length(keys(var.cors_rule)) == 0 ? 0 : 1
  bucket = aws_s3_bucket.s3_bucket.id
  cors_rule {
    allowed_methods = lookup(var.cors_rule, "allowed_methods", null)
    allowed_origins = lookup(var.cors_rule, "allowed_origins", null)
    allowed_headers = lookup(var.cors_rule, "allowed_headers", null)
    expose_headers  = lookup(var.cors_rule, "expose_headers", null)
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_config" {
  count  = length(keys(var.website_hosting)) == 0 ? 0 : 1
  bucket = aws_s3_bucket.s3_bucket.id
  index_document {
    suffix = lookup(var.website_hosting, "index_document", "index.html")
  }
  error_document {
    key = lookup(var.website_hosting, "error_document", "error.html")
  }
  routing_rules = lookup(var.website_hosting, "routing_rules", null)
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    id     = "standard_lifecycle"
    status = var.object_lifecycle_management

    transition {
      days          = var.standard_ia_transition
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.glacier_transition
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.glacier_transition
    }

    expiration {
      days = var.expiration_days
    }
  }

  rule {
    id     = "non_current_transition"
    status = var.non_current_transition

    noncurrent_version_transition {
      noncurrent_days = var.non_current_transition_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.non_current_expiration_days
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "intelligent_tiering_config" {
  for_each = local.intelligent_tiering_configuration
  bucket   = aws_s3_bucket.s3_bucket.id
  name     = each.key
  status   = each.value.status
  dynamic "filter" {
    for_each = each.value.filter
    content {
      prefix = filter.value["prefix"]
      tags   = filter.value["tags"]
    }
  }

  dynamic "tiering" {
    for_each = each.value.tiering
    content {
      access_tier = tiering.key
      days        = tiering.value
    }
  }
}