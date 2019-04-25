# Destination Resources

resource "aws_lambda_function" "copy_rds_snapshot_xaccount_function" {
  count         = "${var.cross_account_copy == true ? 1 : 0}"                                                                                                                                                                                                               # true = cross account
  function_name = "copy_rds_snapshot_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "copy_snapshots_dest_rds.zip"
  memory_size   = "512"
  description   = "This functions copies snapshots for RDS Instances shared with this account. It checks for existing snapshots following the pattern specified in the environment variables with the following format: <dbInstanceIdentifier-identifier>-YYYY-MM-DD-HH-MM"

  environment {
    variables = {
      SNAPSHOT_PATTERN      = "${var.snapshot_pattern}"
      DEST_REGION           = "${var.destination_region}"
      KMS_KEY_DEST_REGION   = "${var.kms_key_destination}"
      KMS_KEY_SOURCE_REGION = "${var.kms_key_source}"
      RETENTION_DAYS        = "${var.retention_days}"
      LOG_LEVEL             = "${var.log_level}"
      REGION_OVERRIDE       = "${var.source_region_override}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}

resource "aws_lambda_function" "copy_rds_snapshot_function" {
  count         = "${var.cross_account_copy == false ? 1 : 0}"                                                                                                                                                                                                              # false = not cross account
  function_name = "copy_rds_snapshot_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "copy_snapshots_no_x_account_rds.zip"
  memory_size   = "512"
  description   = "This functions copies snapshots for RDS Instances shared with this account. It checks for existing snapshots following the pattern specified in the environment variables with the following format: <dbInstanceIdentifier-identifier>-YYYY-MM-DD-HH-MM"

  environment {
    variables = {
      SNAPSHOT_PATTERN      = "${var.snapshot_pattern}"
      DEST_REGION           = "${var.destination_region}"
      KMS_KEY_DEST_REGION   = "${var.kms_key_destination}"
      KMS_KEY_SOURCE_REGION = "${var.kms_key_source}"
      RETENTION_DAYS        = "${var.retention_days}"
      LOG_LEVEL             = "${var.log_level}"
      REGION_OVERRIDE       = "${var.source_region_override}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}

resource "aws_lambda_function" "delete_old_rds_snapshot_dest_xaccount_function" {
  count         = "${var.cross_account_copy == true && var.delete_old_snapshots == true ? 1 : 0}"                                               # true = cross account
  function_name = "delete_old_rds_snapshot_dest_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "delete_old_snapshots_dest_rds.zip"
  memory_size   = "512"
  description   = "This function enforces retention on the snapshots shared with the destination account. "

  environment {
    variables = {
      SNAPSHOT_PATTERN = "${var.snapshot_pattern}"
      DEST_REGION      = "${var.destination_region}"
      RETENTION_DAYS   = "${var.retention_days}"
      LOG_LEVEL        = "${var.log_level}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}

resource "aws_lambda_function" "delete_old_rds_snapshot_dest_function" {
  count         = "${var.cross_account_copy == false && var.delete_old_snapshots == true ? 1 : 0}"                                               # false = not cross account
  function_name = "delete_old_rds_snapshot_dest_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "delete_old_snapshots_no_x_account_rds.zip"
  memory_size   = "512"
  description   = "This function enforces retention on the snapshots shared with the destination account. "

  environment {
    variables = {
      SNAPSHOT_PATTERN = "${var.snapshot_pattern}"
      DEST_REGION      = "${var.destination_region}"
      RETENTION_DAYS   = "${var.retention_days}"
      LOG_LEVEL        = "${var.log_level}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}
