resource "aws_s3_bucket_replication_configuration" "replication" {
  for_each = { for replica in local.replicas : replica["bucket_name"] => replica }
  bucket   = var.source_s3_bucket
  role     = local.s3_replication_role

  rule {
    status   = "Enabled"
    id       = "${each.key}-replication-rule"
    priority = lookup(each.value, "priority")

    destination {
      bucket = "arn:aws:s3:::${each.key}"
      access_control_translation {
        owner = "Destination"
      }
      storage_class = var.replication_storage_class
    }

    delete_marker_replication {
      status = lookup(each.value, "delete_marker_replication_enabled")
    }

    source_selection_criteria {
      replica_modifications {
        status = lookup(each.value, "replica_modifications_enabled")
      }
    }
    existing_object_replication {
      status = "Enabled"
    }
  }

}
