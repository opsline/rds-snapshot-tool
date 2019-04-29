# Destination Resources

resource "aws_cloudwatch_metric_alarm" "rds_copy_failed_dest_alarm" {
  alarm_name          = "rds_copy_failed_dest_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ExecutionsFailed"
  namespace           = "AWS/States"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = ["${aws_sns_topic.rds_copy_failed_dest_topic.arn}"]

  dimensions {
    StateMachineArn = "${aws_sfn_state_machine.copy_rds_snapshot_dest.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_delete_old_failed_dest_alarm" {
  count               = "${var.delete_old_snapshots == true ? 1 : 0}"
  alarm_name          = "rds_delete_old_failed_dest_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ExecutionsFailed"
  namespace           = "AWS/States"
  period              = "3600"
  statistic           = "Sum"
  threshold           = "2"
  alarm_actions       = ["${aws_sns_topic.rds_delete_old_failed_dest_topic.arn}"]

  dimensions {
    StateMachineArn = "${aws_sfn_state_machine.delete_old_rds_snapshot_dest.id}"
  }
}

resource "aws_cloudwatch_event_rule" "copy_rds_snapshot_event" {
  name                = "copy_rds_snapshot_event"
  description         = "Triggers the RDS Copy state machine in the destination account"
  schedule_expression = "cron(/30 * * * ? *)"
  role_arn            = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_event_rule" "delete_old_rds_snapshot_dest_event" {
  count               = "${var.delete_old_snapshots == true ? 1 : 0}"
  name                = "delete_old_rds_snapshot_dest_event"
  description         = "Triggers the DeleteOldSnapshotsRDS state machine"
  schedule_expression = "cron(0 /1 * * ? *)"
  role_arn            = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_event_target" "copy_rds_snapshot_dest_event_target" {
  target_id = "copy_rds_snapshot_dest_target"
  arn       = "${aws_sfn_state_machine.copy_rds_snapshot_dest.id}"
  rule      = "${aws_cloudwatch_event_rule.copy_rds_snapshot_event.name}"
  role_arn  = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_event_target" "delete_old_rds_snapshot_dest_event_target" {
  count     = "${var.delete_old_snapshots == true ? 1 : 0}"
  target_id = "delete_old_rds_snapshot_dest_target"
  arn       = "${aws_sfn_state_machine.delete_old_rds_snapshot_dest.id}"
  rule      = "${aws_cloudwatch_event_rule.delete_old_rds_snapshot_dest_event.name}"
  role_arn  = "${aws_iam_role.step_invocation_role.arn}"
}

resource "aws_cloudwatch_log_group" "copy_rds_snapshot_function_lg" {
  name              = "/aws/lambda/copy_rds_snapshot_function"
  retention_in_days = "${var.lambda_cw_log_retention}"
}

resource "aws_cloudwatch_log_group" "delete_old_rds_snapshot_dest_function_lg" {
  count             = "${var.delete_old_snapshots == true ? 1 : 0}"
  name              = "/aws/lambda/delete_old_rds_snapshot_dest_function"
  retention_in_days = "${var.lambda_cw_log_retention}"
}
