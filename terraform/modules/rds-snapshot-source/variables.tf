# AWS settings
variable "region" {
  type = "string"
}

variable "profile" {
  type = "string"
}

# Source Settings

# This variable is currently unused in favor of only using the AWS Managed Buckets
# variable "code_bucket" {
#   type    = "string"
#   default = "DEFAULT_BUCKET"

#   # Description: "Name of the bucket that contains the lambda functions to deploy. Leave the default value to download the code from the AWS Managed buckets."
# }

variable "instance_name_pattern" {
  type = "string"
  default = "ALL_INSTANCES"

  # Default: ALL_INSTANCES
  # Description: "Python regex for matching cluster identifiers to backup. Use "ALL_INSTANCES" to back up every RDS instance in the region."
}

variable "backup_interval" {
  type    = "string"
  default = "24"

  # Description: "Interval for backups in hours. Default is 24"
}

variable "destination_account" {
  type    = "string"
  default = ""

  # Description: "Destination account with no dashes."
}

variable "source_account" {
  type = "string"

  # EX: 123456789012
  # Description: "Source account with no dashes."
}

variable "share_snapshots" {
  type    = "string"
  default = "false"

  # AllowedValues: "true" OR "false"
}

variable "backup_schedule" {
  type    = "string"
  default = "0 1 * * ? *"

  # Description: "Backup schedule in Cloudwatch Event cron format. Needs to run at least once for every Interval. The default value runs once every at 1AM UTC. More information: http://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
}

variable "retention_days" {
  type    = "string"
  default = "7"

  # Description: "string of days to keep snapshots in retention before deleting them"
}

variable "log_level" {
  type    = "string"
  default = "ERROR"

  # Description: "Log level for Lambda functions (DEBUG, INFO, WARN, ERROR, CRITICAL are valid values)."
}

variable "lambda_cw_log_retention" {
  type    = "string"
  default = "7"

  # Description: "string of days to retain logs from the lambda functions in CloudWatch Logs"
}

variable "source_region_override" {
  type    = "string"
  default = "NO"

  # Description: "Set to the region where your RDS instances run, only if such region does not support Step Functions. Leave as NO otherwise"
}

variable "delete_old_snapshots" {
  type    = "string"
  default = "true"

  # Description: "Set to true to enable deletion of snapshot based on RetentionDays. Set to false to disable"
  # AllowedValues: "true" OR "false"
}

variable "tagged_instance" {
  type    = "string"
  default = "false"

  # Description: "Set to true to filter instances that have tag CopyDBSnapshot set to True. Set to false to disable"
  # AllowedValues: "true" OR "false"
}
