
# If it's commented, it's default.

region = "us-west-2"
profile = "opsline-corp"

source_account = "253379484728"
# code_bucket = "DEFAULT_BUCKET"
# instance_name_pattern = "ALL_INSTANCES"
backup_interval = "1"
destination_account = "253379484728"
share_snapshots = "false"
backup_schedule = "0/30 * * * ? *"
retention_days = "1"
log_level = "INFO"
lambda_cw_log_retention = "1"
# source_region_override = "NO"
# delete_old_snapshots = "true"
tagged_instance = "FALSE"
