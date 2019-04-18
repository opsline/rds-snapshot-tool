resource "aws_lambda_function" "take_rds_snapshot_function" {
  function_name = "take_rds_snapshot_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "take_snapshots_rds.zip"
  memory_size   = "512"
  description   = "This functions triggers snapshots creation for RDS instances. It checks for existing snapshots following the pattern and interval specified in the environment variables with the following format: <dbinstancename>-YYYY-MM-DD-HH-MM"

  environment {
    variables = {
      INTERVAL        = "${var.backup_interval}"
      PATTERN         = "${var.instance_name_pattern}"
      LOG_LEVEL       = "${var.log_level}"
      REGION_OVERRIDE = "${var.source_region_override}"
      TAGGEDINSTANCE  = "${var.tagged_instance}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}

resource "aws_lambda_function" "share_rds_snapshot_function" {
  function_name = "share_rds_snapshot_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "share_snapshots_rds.zip"
  memory_size   = "512"
  description   = "This function shares snapshots created by the take_snapshots_rds function with DEST_ACCOUNT specified in the environment variables."

  environment {
    variables = {
      DEST_ACCOUNT    = "${var.backup_interval}"
      PATTERN         = "${var.instance_name_pattern}"
      LOG_LEVEL       = "${var.log_level}"
      REGION_OVERRIDE = "${var.source_region_override}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}

resource "aws_lambda_function" "delete_old_rds_snapshot_function" {
  function_name = "delete_old_rds_snapshot_function"
  s3_bucket     = "snapshots-tool-rds-${var.region}"
  s3_key        = "delete_old_snapshots_rds.zip"
  memory_size   = "512"
  description   = "This function deletes snapshots created by the take_snapshots_rds function."

  environment {
    variables = {
      RETENTION_DAYS  = "${var.backup_interval}"
      PATTERN         = "${var.instance_name_pattern}"
      LOG_LEVEL       = "${var.log_level}"
      REGION_OVERRIDE = "${var.source_region_override}"
    }
  }

  role    = "${aws_iam_role.rds_snapshot_role.arn}"
  runtime = "python3.6"
  handler = "lambda_function.lambda_handler"
  timeout = "300"
}
