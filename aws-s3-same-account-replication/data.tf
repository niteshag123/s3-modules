locals {
  s3_replication_role = var.replication_role != null ? var.replication_role : data.aws_iam_role.replication_role[0].arn
  replicas = [
    for destination in var.destination_s3_buckets : {
      bucket_name                       = destination["bucket_name"]
      priority                          = index(var.destination_s3_buckets, destination)
      replica_modifications_enabled     = destination["replica_modifications_enabled"] ? "Enabled" : "Disabled"
      delete_marker_replication_enabled = destination["delete_marker_replication_enabled"] ? "Enabled" : "Disabled"
    } if destination["account_id"] == data.aws_caller_identity.identity.account_id
  ]
}

data "aws_caller_identity" "identity" {}

data "aws_iam_role" "replication_role" {
  count = var.replication_role != null ? 0 : 1
  name  = module.account_config.account_base_details[data.aws_caller_identity.identity.account_id]["s3_replication_role"]
}


module "account_config" {
  source      = "git::https://gitlab.ihsmarkit.com/reference-data/aws/refdata-terraform-modules/base-config.git"
  service     = var.service
  application = var.application
  environment = var.environment
}