# RDS Snapshot with Terraform

In this contains the terraform scripts ported from the cloudformation templates to create the rds_snapshot setup. Most settings are one-to-one with the original, however because of limited logic within Terraform, some changes had to be made. Primarily, the source and destination configuration files are separate and somewhat redundant. The `run.sh` script takes this into account, but both source and destination needs to be configured properly.

## Initial Steps

* In the aws directory, create an environment/application named directory with a source and destination directory inside.

``` bash
mkdir -p aws/[environment|application]/{source, destination}
```

* Each source and destination directory should contain a `backend.tfvars` and `terraform.tfvars` files.

### aws/[environment|application]/source/backend.tfvars

``` terraform
bucket = "<name of the terraform state s3 bucket>"
dynamodb_table = "<name of the terraform state lock dynamodb table>"
key = "<region|namespace>/<name of the source state file>"
region = "<source region>"
encrypt = true
profile = "<aws credential profile>"
```

### aws/[environment|application]/source/terraform.tfvars

``` terraform
region = "<source region>"
profile = "<aws credential profile>"

source_account = "<source aws account number>"
# code_bucket = "DEFAULT_BUCKET" # Leave this as is
instance_name_pattern = "<python regex for rds instance to snapshot>"
# backup_interval = "7"
destination_account = "<destination aws account number>"
# share_snapshots = "false"
# backup_schedule = "0 1 * * ? *"
# retention_days = "7"
# log_level = "ERROR"
# lambda_cw_log_retention = "7"
# source_region_override = "NO"
# delete_old_snapshots = "true"
# tagged_instance = "FALSE"
```

### aws/[environment|application]/destination/backend.tfvars

``` terraform
bucket = "<name of the terraform state s3 bucket>"
dynamodb_table = "<name of the terraform state lock dynamodb table>"
key = "<region|namespace>/<name of the destination state file>"
region = "<source region>"
encrypt = true
profile = "<aws credential profile>"
```

### aws/[environment|application]/destination/terraform.tfvars

``` terraform
region = "<source region>"
profile = "<aws credential profile>"

# log_level = "ERROR"
# retention_days = "7"
destination_account = "<destination aws account number>"
# source_region_override = "NO"
snapshot_pattern = "<python regex for rds snapshot to copy>"
destination_region = "<destination region>"
# kms_key_destination = "None"
# kms_key_source = "None"
# cross_account_copy = "false"
# delete_old_snapshots = "true"
# lambda_cw_log_retention = "7"
```

## Run It

From the terraform directory

``` bash
./run.sh [environment/application] [plan|apply|destroy]
```