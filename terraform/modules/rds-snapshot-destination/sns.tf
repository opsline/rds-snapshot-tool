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
      variable = "AWS:SourceOwner"

      values = [
        "${var.destination_account}",
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
