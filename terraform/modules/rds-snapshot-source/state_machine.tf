
resource "aws_sfn_state_machine" "take_rds_snapshot" {
  name     = "take_rds_snapshot"
  role_arn = "${aws_iam_role.state_execution_role.arn}"

  definition = <<EOF
{
    "Comment": "Triggers snapshot backup for RDS instances",
    "StartAt": "TakeSnapshots",
    "States": {
    "TakeSnapshots": {
        "Type": "Task",
        "Resource": "arn:aws:lambda:${var.region}:${var.source_account}:function:take_rds_snapshot_function",
        "Retry": [
        {
            "ErrorEquals": [ "SnapshotToolException" ],
            "IntervalSeconds": 300,
            "MaxAttempts": 20,
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

resource "aws_sfn_state_machine" "share_rds_snapshot" {
  name     = "share_rds_snapshot"
  role_arn = "${aws_iam_role.state_execution_role.arn}"

  definition = <<EOF
{
    "Comment": "Shares snapshots with DEST_ACCOUNT",
    "StartAt": "ShareSnapshots",
    "States": {
    "ShareSnapshots": {
        "Type": "Task",
        "Resource": "arn:aws:lambda:${var.region}:${var.source_account}:function:share_rds_snapshot_function",
        "Retry": [
        {
            "ErrorEquals": [ "SnapshotToolException" ],
            "IntervalSeconds": 300,
            "MaxAttempts": 3,
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

resource "aws_sfn_state_machine" "delete_old_rds_snapshot" {
  name     = "delete_old_rds_snapshot"
  role_arn = "${aws_iam_role.state_execution_role.arn}"

  definition = <<EOF
{
    "Comment": "DeleteOld management for RDS snapshots",
    "StartAt": "DeleteOld",
    "States": {
    "DeleteOld": {
        "Type": "Task",
        "Resource": "arn:aws:lambda:${var.region}:${var.source_account}:function:delete_old_rds_snapshot_function",
        "Retry": [
        {
            "ErrorEquals": [ "SnapshotToolException" ],
            "IntervalSeconds": 300,
            "MaxAttempts": 7,
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