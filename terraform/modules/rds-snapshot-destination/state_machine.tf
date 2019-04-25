resource "aws_sfn_state_machine" "copy_rds_snapshot_dest" {
  name     = "copy_rds_snapshot_dest"
  role_arn = "${aws_iam_role.state_execution_role.arn}"

  definition = <<EOF
{
  "Comment": "Copies snapshots locally and then to DEST_REGION",
  "StartAt": "CopySnapshots",
  "States": {
    "CopySnapshots": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${var.region}:${var.destination_account}:function:copy_rds_snapshot_function",
      "Retry": [
        {
          "ErrorEquals": [ "SnapshotToolException" ],
          "IntervalSeconds": 300,
          "MaxAttempts": 5,
          "BackoffRate": 1
        },
        {
          "ErrorEquals": [ "States.ALL" ],
          "IntervalSeconds": 30,
          "MaxAttempts": 20,
          "BackoffRate": 1
        }
      ],
      "End": true
    }
  }
}
EOF
}

resource "aws_sfn_state_machine" "delete_old_rds_snapshot_dest" {
  count       = "${var.delete_old_snapshots == true ? 1 : 0}"
  name     = "delete_old_rds_snapshot_dest"
  role_arn = "${aws_iam_role.state_execution_role.arn}"

  definition = <<EOF
{
  "Comment": "DeleteOld for RDS snapshots in destination region",
  "StartAt": "DeleteOldDestRegion",
  "States": {
    "DeleteOldDestRegion": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${var.region}:${var.destination_account}:function:delete_old_rds_snapshot_dest_function",
      "Retry": [
        {
          "ErrorEquals": [ "SnapshotToolException" ],
          "IntervalSeconds": 600,
          "MaxAttempts": 5,
          "BackoffRate": 1
        },
        {
          "ErrorEquals": [ "States.ALL" ],
          "IntervalSeconds": 30,
          "MaxAttempts": 20,
          "BackoffRate": 1
        }
      ],
      "End": true
    }
  }
}
EOF
}
