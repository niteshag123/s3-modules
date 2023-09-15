module "test_bucket_primary" {
  source        = "git::https://gitlab.ihsmarkit.com/reference-data/aws/refdata-terraform-modules/aws-s3.git"
  bucket_name   = "test-files"
  environment   = "test"
  application   = "REFDATA"
  force_destroy = true
  versioning    = true
  service       = "REFDATA"
  providers = {
    aws = aws.ireland
  }
}

module "test_bucket_secondary" {
  source        = "git::https://gitlab.ihsmarkit.com/reference-data/aws/refdata-terraform-modules/aws-s3.git"
  bucket_name   = "test-files"
  environment   = "test"
  application   = "REFDATA"
  force_destroy = true
  versioning    = true
  service       = "REFDATA"
  providers = {
    aws = aws.london
  }
}


data "aws_caller_identity" "current_host" {
  provider = aws.ireland
}

data "aws_caller_identity" "current_destination" {
  provider = aws.london
}

module "replication_primary" {
  source      = "../"
  environment = "test"

  source_s3_bucket = module.test_bucket_primary.s3_bucket_id
  replication_role = "arn:aws:iam::248710618697:role/test-s3-replication-role"
  destination_s3_buckets = [
    {
      bucket_name                       = module.test_bucket_secondary.s3_bucket_id
      account_id                        = data.aws_caller_identity.current_host.account_id
      delete_marker_replication_enabled = true
      replica_modifications_enabled     = true
    }
  ]

  providers = {
    aws = aws.ireland
  }
  application = "REFDATA"
  service     = "REFDATA"
}

module "replication_reverse" {
  source      = "../"
  environment = "test"

  source_s3_bucket = module.test_bucket_secondary.s3_bucket_id
  replication_role = "arn:aws:iam::248710618697:role/test-s3-replication-role"
  destination_s3_buckets = [
    {
      bucket_name                       = module.test_bucket_primary.s3_bucket_id
      account_id                        = data.aws_caller_identity.current_host.account_id
      delete_marker_replication_enabled = true
      replica_modifications_enabled     = true
    }
  ]

  providers = {
    aws = aws.london
  }
  application = "REFDATA"
  service     = "REFDATA"
}