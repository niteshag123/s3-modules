# aws-s3-same-account-replication

This is the Refdata AWS S3 Replication Module for the same account

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a     |

## Modules

| Name                                                   | Source                                                                                         | Version |
|--------------------------------------------------------|------------------------------------------------------------------------------------------------|---------|
| <a name="module_config"></a> [config](#module\_config) | git::https://gitlab.ihsmarkit.com/reference-data/aws/refdata-terraform-modules/base-config.git | n/a     |

## Resources

| Name                                                                                                                                                                   | Type        |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_s3_bucket_replication_configuration.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource    |
| [aws_caller_identity.identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                         | data source |

## Inputs

| Name                                                                                                              | Description                                                                                                                                                     | Type                                                                                                                                                                                                                                  | Default      | Required |
|-------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|:--------:|
| <a name="input_application"></a> [application](#input\_application)                                               | Application under service that will use the bucket e.g. WMDATEN, IPREO                                                                                          | `string`                                                                                                                                                                                                                              | n/a          |   yes    |
| <a name="input_destination_s3_buckets"></a> [destination\_s3\_buckets](#input\_destination\_s3\_buckets)          | List of Destination buckets for replication                                                                                                                     | <pre>list(object({<br>    bucket_name                       = string<br>    account_id                        = string<br>    replica_modifications_enabled     = bool<br>    delete_marker_replication_enabled = bool<br>  }))</pre> | n/a          |   yes    |
| <a name="input_environment"></a> [environment](#input\_environment)                                               | n/a                                                                                                                                                             | `string`                                                                                                                                                                                                                              | n/a          |   yes    |
| <a name="input_replication_role"></a> [replication\_role](#input\_replication\_role)                              | n/a                                                                                                                                                             | `string`                                                                                                                                                                                                                              | `null`       |    no    |
| <a name="input_replication_storage_class"></a> [replication\_storage\_class](#input\_replication\_storage\_class) | The class of storage used to store the object.Can be STANDARD, REDUCED\_REDUNDANCY, STANDARD\_IA, ONEZONE\_IA, INTELLIGENT\_TIERING, GLACIER, or DEEP\_ARCHIVE. | `string`                                                                                                                                                                                                                              | `"STANDARD"` |    no    |
| <a name="input_service"></a> [service](#input\_service)                                                           | Service that will use the bucket e.g. BRD, SPRD, RED, Entity, Equity                                                                                            | `string`                                                                                                                                                                                                                              | n/a          |   yes    |
| <a name="input_source_s3_bucket"></a> [source\_s3\_bucket](#input\_source\_s3\_bucket)                            | n/a                                                                                                                                                             | `string`                                                                                                                                                                                                                              | n/a          |   yes    |

## Outputs

| Name                                                                                         | Description |
|----------------------------------------------------------------------------------------------|-------------|
| <a name="output_replication_config"></a> [replication\_config](#output\_replication\_config) | n/a         |
