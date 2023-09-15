resource "aws_s3_bucket" "s3_bucket" {
  bucket              = local.bucket_name
  force_destroy       = var.force_destroy
  object_lock_enabled = false
  tags                = merge({ Name = local.bucket_name }, local.common_tags)
}