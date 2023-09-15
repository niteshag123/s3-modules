data "aws_region" "current" {}

locals {
  bucket_name = "${lower(var.service)}-${lower(var.bucket_name)}-${data.aws_region.current.name}-${lower(var.environment)}"
  intelligent_tiering_configuration = {
    for key, value in var.intelligent_tiering_configuration : key => {
      filter = value.filter == null ? {} : {
        filter = value.filter
      }
      tiering = value.tiering
      status  = value.enabled ? "Enabled" : "Disabled"
    }
  }

  versioning = var.versioning ? "Enabled" : "Disabled"
}
