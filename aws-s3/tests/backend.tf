terraform {
  backend "s3" {
  }
}

provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}
