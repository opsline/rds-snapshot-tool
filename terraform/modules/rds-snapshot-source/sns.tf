# Source Resources

resource "aws_sns_topic" "backups_failed_topic" {
  display_name = "backups_failed_rds"
}

resource "aws_sns_topic" "share_failed_topic" {
  display_name = "share_failed_rds"
}

resource "aws_sns_topic" "delete_old_failed_topic" {
  display_name = "delete_old_failed_rds"
}

data "aws_iam_policy_document" "rds_snapshot_topic_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "${var.source_account}",
      ]
    }
  }
}

resource "aws_sns_topic_policy" "backups_failed_topic_policy" {
  arn = "${aws_sns_topic.backups_failed_topic.arn}"

  policy = "${data.aws_iam_policy_document.rds_snapshot_topic_policy.json}"
}

resource "aws_sns_topic_policy" "share_failed_topic_policy" {
  arn = "${aws_sns_topic.share_failed_topic.arn}"

  policy = "${data.aws_iam_policy_document.rds_snapshot_topic_policy.json}"
}

resource "aws_sns_topic_policy" "delete_old_failed_topic_policy" {
  arn = "${aws_sns_topic.delete_old_failed_topic.arn}"

  policy = "${data.aws_iam_policy_document.rds_snapshot_topic_policy.json}"
}
