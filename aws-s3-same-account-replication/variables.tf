variable "environment" {
  type = string
}

variable "source_s3_bucket" {
  type = string
}

variable "replication_role" {
  type    = string
  default = null
}

variable "destination_s3_buckets" {
  description = "List of Destination buckets for replication"
  type = list(object({
    bucket_name                       = string
    account_id                        = string
    replica_modifications_enabled     = bool
    delete_marker_replication_enabled = bool
  }))
}

variable "replication_storage_class" {
  description = "The class of storage used to store the object.Can be STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE."
  type        = string
  default     = "STANDARD"
  validation {
    condition = (contains([
      "STANDARD", "REDUCED_REDUNDANCY", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING", "GLACIER", "DEEP_ARCHIVE"
    ], var.replication_storage_class))
    error_message = "Class of storage can be STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE."
  }
}

variable "service" {
  type        = string
  description = "Service that will use the bucket e.g. BRD, SPRD, RED, Entity, Equity"
}

variable "application" {
  type        = string
  description = "Application under service that will use the bucket e.g. WMDATEN, IPREO"
}