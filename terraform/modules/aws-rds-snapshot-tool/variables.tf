# AWS settings
variable "region" {
  type = "string"
}

variable "profile" {
  type = "string"
}


# Source Settings
variable "code_bucket" {
  type = "string"

  # Default: DEFAULT_BUCKET
  # Description: 'Name of the bucket that contains the lambda functions to deploy. Leave the default value to download the code from the AWS Managed buckets.'
}

variable "instance_name_pattern" {
  type = "string"

  # Default: ALL_INSTANCES
  # Description: 'Python regex for matching cluster identifiers to backup. Use "ALL_INSTANCES" to back up every RDS instance in the region.'
}

variable "backup_interval" {
  type    = "string"
  default = "24"

  # Description: 'Interval for backups in hours. Default is 24'
}

variable "destination_account" {
  type    = "string"
  default = "000000000000"

  # Description: 'Destination account with no dashes.'
}
variable "source_account" {
  type = "string"
  # EX: 123456789012
  # Description: 'Source account with no dashes.'
}

variable "share_snapshots" {
  type    = "string"
  default = "true"

  # AllowedValues: 'true' OR 'false'
}

variable "backup_schedule" {
  type    = "string"
  default = "0 1 * * ? *"

  # Description: 'Backup schedule in Cloudwatch Event cron format. Needs to run at least once for every Interval. The default value runs once every at 1AM UTC. More information: http://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html'
}

variable "retention_days" {
  type    = "string"
  default = "7"

  # Description: 'string of days to keep snapshots in retention before deleting them'
}

variable "log_level" {
  type    = "string"
  default = "ERROR"

  # Description: 'Log level for Lambda functions (DEBUG, INFO, WARN, ERROR, CRITICAL are valid values).'
}

variable "lambda_cw_log_retention" {
  type    = "string"
  default = "7"

  # Description: 'string of days to retain logs from the lambda functions in CloudWatch Logs'
}

variable "source_region_override" {
  type    = "string"
  default = "NO"

  # Description: 'Set to the region where your RDS instances run, only if such region does not support Step Functions. Leave as NO otherwise'
}

variable "delete_old_snapshots" {
  type    = "string"
  default = "true"

  # Description: 'Set to true to enable deletion of snapshot based on RetentionDays. Set to false to disable'
  # AllowedValues: 'true' OR 'false'
}

variable "tagged_instance" {
  type    = "string"
  default = "false"

  # Description: 'Set to true to filter instances that have tag CopyDBSnapshot set to True. Set to false to disable'
  # AllowedValues: 'true' OR 'false'
}

# Destination ONLY Settings

variable "snapshot_pattern" {
  type = "string"

  # Default: ALL_SNAPSHOTS
  # Description: 'Python regex for matching instance names to backup. Use "ALL_SNAPSHOTS" to back up every RDS instance in the region.'
}

variable "destination_region" {
  type = "string"

  # Description: 'Destination region for snapshots.'
}

variable "kms_key_destination" {
  type    = "string"
  default = "None"

  # Description: 'Set to the ARN for the KMS key in the destination region to re-encrypt encrypted snapshots. Leave None if you are not using encryption'
}

variable "kms_key_source" {
  type    = "string"
  default = "None"

  # Description: 'Set to the ARN for the KMS key in the SOURCE region to re-encrypt encrypted snapshots. Leave None if you are not using encryption'
}

variable "cross_account_copy" {
  type    = "string"
  default = "true"

  # AllowedValues: 'true' OR 'false'
  # Description: 'Enable copying snapshots across accounts. Set to false if your source snapshosts are not on a different account'
}
