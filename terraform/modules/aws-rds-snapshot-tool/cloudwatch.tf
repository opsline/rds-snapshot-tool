
resource "aws_cloudwatch_metric_alarm" "alarm_cw_backups_failed" {
  alarm_name = "rds_snapshot_backups_failed"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ExecutionsFailed"
  namespace                 = "AWS/States"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions = ["${aws_sns_topic.backups_failed_topic.arn}"]
  dimensions {
      StateMachineArn = "" # stateMachineTakeSnapshotsRDS
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_cw_share_failed" {
  alarm_name = "rds_snapshot_share_failed"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "ExecutionsFailed"
  namespace                 = "AWS/States"
  period                    = "3600"
  statistic                 = "Sum"
  threshold                 = "2"
  alarm_actions = ["${aws_sns_topic.share_failed_topic.arn}"]
  dimensions {
      StateMachineArn = "" # statemachineShareSnapshotsRDS
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_cw_delete_old_failed" {
  alarm_name = "rds_snapshot_delete_old_failed"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "ExecutionsFailed"
  namespace                 = "AWS/States"
  period                    = "3600"
  statistic                 = "Sum"
  threshold                 = "2"
  alarm_actions = ["${aws_sns_topic.delete_old_failed_topic.arn}"]
  dimensions {
      StateMachineArn = "" # statemachineDeleteOldSnapshotsRDS
  }
}

  