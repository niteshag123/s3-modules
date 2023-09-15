variable "bucket_name" {
  type        = string
  description = "Name or service for which the bucket will be used"
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "service" {
  type        = string
  description = "Service that will use the bucket"
}

variable "application" {
  type        = string
  description = "Application under service that will use the bucket"
}

variable "bucket_policy" {
  description = "Policy in JSON format that will be passed to the bucket"
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "(Optional) A boolean that indicates if bucket versioning shall be enabled. If replication is enabled, versioning is also enabled as a requirement."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "object_lifecycle_management" {
  description = "(Optional) A boolean that indicates whether or not to implement lifecycle rules for a bucket"
  type        = string
  default     = "Enabled"
}

variable "non_current_transition" {
  description = "(Optional) A boolean that indicates non_current objects should be transitioned or not"
  type        = string
  default     = "Enabled"
}

variable "standard_ia_transition" {
  description = "(Optional) Number of days before objects are transitioned to a single IA Zone for cost saving"
  type        = number
  default     = 180
}

variable "glacier_transition" {
  description = "Number of days before objects in the bucket are transitioned to Glacier for Archive"
  type        = number
  default     = 365
}

variable "expiration_days" {
  description = "Number of days before objects expire in the bucket"
  type        = number
  default     = 732
}

variable "non_current_expiration_days" {
  description = "Number of days before non current objects in the bucket are removed"
  type        = number
  default     = 90
}

variable "non_current_transition_days" {
  description = "Number of days after non current objects are transitioned to STANDARD_IA"
  type        = number
  default     = 30
}


variable "acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = null
}

variable "website_hosting" {
  description = "(Optional) Map containing a list of items to use for the Website Configuration"
  type        = any
  default     = {}
}

variable "cors_rule" {
  description = "Map containing a rule of Cross-Origin Resource Sharing."
  type        = any # should be `map`, but it produces an error "all map elements must have the same type"
  default     = {}
}

variable "intelligent_tiering_configuration" {
  description = "Configuration determining what (if any) filters for intelligent tiering are used and the archive details"
  type = map(object({
    filter = object({
      tags   = map(string)
      prefix = string
    })
    tiering = map(number)
    enabled = bool
  }))
  default = {}

  validation {
    condition     = length(flatten([for key, value in var.intelligent_tiering_configuration : [for tk in keys(value.tiering) : tk if !contains(["ARCHIVE_ACCESS", "DEEP_ARCHIVE_ACCESS"], tk)]])) == 0
    error_message = "The tiering keys for the intelligent_tiering_configuration tiering blocks must be either 'ARCHIVE_ACCESS' or 'DEEP_ARCHIVE_ACCESS'."
  }

  validation {
    condition     = length([for key, value in var.intelligent_tiering_configuration : key if length(try(keys(value.tiering), [])) == 0]) == 0
    error_message = "The tiering block for each intelligent_tiering_configuration must have at least one key."
  }
}

variable "lifecycle_configuration" {
  type    = any
  default = {}

  validation {
    condition     = length([for key, value in var.lifecycle_configuration : key if !can(value.enabled) || try(type(value.enabled) == "bool", false)]) == 0
    error_message = "The variable lifecycle_configuration must be a map of objects containing a bool for enabled."
  }

  validation {
    condition     = length([for key, value in var.lifecycle_configuration : key if !can(value.expiration_days) && !can(value.noncurrent_version_expiration_days) && !can(value.noncurrent_version_transition) && !can(value.transition)]) == 0
    error_message = "The variable lifecycle_configuration must be a map of objects containing at least one of expiration_days, noncurrent_version_expiration_days, noncurrent_version_transition or transition."
  }
}
