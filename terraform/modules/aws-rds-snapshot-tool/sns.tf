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
      variable = "AWS::AccountId"

      values = [
        "AWS:SourceOwner",
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

# Destination Resources

resource "aws_sns_topic" "rds_copy_failed_dest_topic" {
  display_name = "rds_copy_failed_dest_topic"
}

resource "aws_sns_topic" "rds_delete_old_failed_dest_topic" {
  display_name = "rds_delete_old_failed_dest_topic"
}

data "aws_iam_policy_document" "rds_failed_dest_policy" {
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
      variable = "AWS::AccountId"

      values = [
        "AWS:SourceOwner",
      ]
    }
  }
}

resource "aws_sns_topic_policy" "rds_copy_failed_dest_topic_policy" {
  arn = "${aws_sns_topic.rds_copy_failed_dest_topic.arn}"

  policy = "${data.aws_iam_policy_document.rds_failed_dest_policy.json}"
}

resource "aws_sns_topic_policy" "rds_delete_old_failed_dest_topic_policy" {
  arn = "${aws_sns_topic.rds_delete_old_failed_dest_topic.arn}"

  policy = "${data.aws_iam_policy_document.rds_failed_dest_policy.json}"
}
