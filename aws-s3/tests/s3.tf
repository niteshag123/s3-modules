module "s3_bucket_website" {
  source = "../"

  standard_ia_transition = 30
  glacier_transition     = 90
  expiration_days        = 120

  bucket_name = "s3-tf-website-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  website_hosting = {
    index_document = "index.html"
  }

  cors_rule     = { "allowed_methods" : ["PUT"], "allowed_origins" : ["https://s3-website-test.hashicorp.com"] }
  force_destroy = true

  tags = {
    Role    = "s3-terraform-module"
    Service = "Reference Data"
    User    = "nishant.jain@ihsmarkit.com"
  }

  providers = {
    aws.primary = aws.ireland
  }
  application = "REFDATA"
  environment = "test"
  service     = "Refdata"
}



module "s3_bucket" {
  source        = "../"
  bucket_name   = "s3-test-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  force_destroy = true

  tags = {
    Role = "Terraform Module Test"
    User = "nishant.jain@ihsmarkit.com"
  }

  providers = {
    aws.primary = aws.ireland
  }
  application = "REFDATA"
  environment = "test"
  service     = "Refdata"
}

module "s3_bucket_intelligent_tiering" {
  source = "../"

  intelligent_tiering_configuration = {
    TestPrefix = {
      filter = {
        tags   = null
        prefix = "/Test"
      }
      tiering = {
        ARCHIVE_ACCESS      = 365
        DEEP_ARCHIVE_ACCESS = 730
      }
      enabled = true
    }
    SecondPrefix = {
      filter = {
        tags   = null
        prefix = "/Second"
      }
      tiering = {
        ARCHIVE_ACCESS      = 366
        DEEP_ARCHIVE_ACCESS = 729
      }
      enabled = true
    }
    Tags = {
      filter = {
        tags = {
          Test = "true"
        }
        prefix = null
      }
      tiering = {
        ARCHIVE_ACCESS      = 367
        DEEP_ARCHIVE_ACCESS = 728
      }
      enabled = true
    }
  }
  lifecycle_configuration = {
    simple_filter = {
      enabled         = true
      expiration_days = 40
      prefix          = "/test"
    }
    noncurrent_version = {
      enabled                            = false
      noncurrent_version_expiration_days = 45
    }
    noncurrent_transition = {
      enabled = true
      prefix  = "/tst1"

      noncurrent_version_transition = {
        GLACIER     = 125
        STANDARD_IA = 45
      }
    }
    transitions = {
      enabled = true

      transition = {
        STANDARD_IA = 195
        GLACIER     = 225
      }
    }
  }

  object_lifecycle_management = "Disabled"

  bucket_name = "s3-tf-intelligent-tiering-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  force_destroy = true

  tags = {
    Role    = "s3-terraform-test"
    Service = "Reference Data"
    User    = "nishant.jain@ihsmarkit.com"
  }

  providers = {
    aws.primary = aws.ireland
  }
  application = "REFDATA"
  environment = "test"
  service     = "Refdata"
}
