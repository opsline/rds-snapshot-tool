
# Source Resources
resource "aws_cloudwatch_metric_alarm" "alarm_cw_backups_failed" {
  alarm_name          = "rds_snapshot_backups_failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ExecutionsFailed"
  namespace           = "AWS/States"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = ["${aws_sns_topic.backups_failed_topic.arn}"]

  dimensions {
    StateMachineArn = "${aws_sfn_state_machine.take_rds_snapshot.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_cw_share_failed" {
  alarm_name          = "rds_snapshot_share_failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ExecutionsFailed"
  namespace           = "AWS/States"
  period              = "3600"
  statistic           = "Sum"
  threshold           = "2"
  alarm_actions       = ["${aws_sns_topic.share_failed_topic.arn}"]

  dimensions {
    StateMachineArn = "${aws_sfn_state_machine.share_rds_snapshot.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_cw_delete_old_failed" {
  alarm_name          = "rds_snapshot_delete_old_failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ExecutionsFailed"
  namespace           = "AWS/States"
  period              = "3600"
  statistic           = "Sum"
  threshold           = "2"
  alarm_actions       = ["${aws_sns_topic.delete_old_failed_topic.arn}"]

  dimensions {
    StateMachineArn = "${aws_sfn_state_machine.delete_old_rds_snapshot.id}"
  }
}

resource "aws_cloudwatch_event_rule" "take_rds_snapshot_event" {
  name                = "take_rds_snapshot_event"
  description         = "Triggers the TakeSnapshotsRDS state machine"
  schedule_expression = "cron(${var.backup_schedule})"
  role_arn            = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_event_rule" "share_rds_snapshot_event" {
  name                = "share_rds_snapshot_event"
  description         = "Triggers the ShareSnapshotsRDS state machine"
  schedule_expression = "cron(/10 * * * ? *)"
  role_arn            = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_event_rule" "delete_old_rds_snapshot_event" {
  name                = "delete_old_rds_snapshot_event"
  description         = "Triggers the DeleteOldSnapshotsRDS state machine"
  schedule_expression = "cron(0 /1 * * ? *)"
  role_arn            = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_log_group" "take_rds_snapshot_lambda_lg" {
  name              = "/aws/lambda/take_rds_snapshot_function"
  retention_in_days = "${var.retention_days}"
}

resource "aws_cloudwatch_log_group" "share_rds_snapshot_lambda_lg" {
  name              = "/aws/lambda/share_rds_snapshot_function"
  retention_in_days = "${var.retention_days}"
}

resource "aws_cloudwatch_log_group" "delete_old_rds_snapshot_lambda_lg" {
  name              = "/aws/lambda/delete_old_rds_snapshot_function"
  retention_in_days = "${var.retention_days}"
}
