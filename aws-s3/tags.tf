module "base_tags" {
  source      = "git::https://gitlab.ihsmarkit.com/reference-data/aws/refdata-terraform-modules/base-config.git"
  service     = var.service
  application = var.application
  environment = var.environment
}

locals {
  common_tags = merge(module.base_tags.tags, var.tags)
}
