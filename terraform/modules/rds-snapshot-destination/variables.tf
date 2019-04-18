# AWS settings
variable "region" {
  type = "string"
}

variable "profile" {
  type = "string"
}

# Shared Settings

# This variable is currently unused in favor of only using the AWS Managed Buckets
# variable "code_bucket" {
#   type    = "string"
#   default = "DEFAULT_BUCKET"

#   # Description: "Name of the bucket that contains the lambda functions to deploy. Leave the default value to download the code from the AWS Managed buckets."
# }

variable "log_level" {
  type    = "string"
  default = "ERROR"

  # Description: "Log level for Lambda functions (DEBUG, INFO, WARN, ERROR, CRITICAL are valid values)."
}

variable "retention_days" {
  type    = "string"
  default = "7"

  # Description: "string of days to keep snapshots in retention before deleting them"
}

variable "destination_account" {
  type    = "string"

  # Description: "Destination account with no dashes."
}

variable "source_region_override" {
  type    = "string"
  default = "NO"

  # Description: "Set to the region where your RDS instances run, only if such region does not support Step Functions. Leave as NO otherwise"
}

# Destination ONLY Settings

variable "snapshot_pattern" {
  type = "string"
  default = ".*"

  # Default: ALL_SNAPSHOTS
  # Description: "Python regex for matching instance names to backup. Use "ALL_SNAPSHOTS" to back up every RDS instance in the region."
}

variable "destination_region" {
  type = "string"

  # Description: "Destination region for snapshots."
}

variable "kms_key_destination" {
  type    = "string"
  default = "None"

  # Description: "Set to the ARN for the KMS key in the destination region to re-encrypt encrypted snapshots. Leave None if you are not using encryption"
}

variable "kms_key_source" {
  type    = "string"
  default = "None"

  # Description: "Set to the ARN for the KMS key in the SOURCE region to re-encrypt encrypted snapshots. Leave None if you are not using encryption"
}

variable "cross_account_copy" {
  type = "string"
  default = "false"

  # Description: 'Enable copying snapshots across accounts. Set to FALSE if your source snapshosts are not on a different account'
  # AllowedValues: 'TRUE' OR 'FALSE'
} 
