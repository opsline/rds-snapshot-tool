output "backups_failed_topic" {
  description = "Subscribe to this topic to receive alerts of failed backups"
  value       = ["${aws_sns_topic.backups_failed_topic.arn}"]
}

output "share_failed_topic" {
  description = "Subscribe to this topic to receive alerts of failures at sharing snapshots with destination account"
  value       = ["${aws_sns_topic.share_failed_topic.arn}"]
}

output "delete_old_failed_topic" {
  description = "Subscribe to this topic to receive alerts of failures at deleting old snapshots"
  value       = ["${aws_sns_topic.delete_old_failed_topic.arn}"]
}

output "source_url" {
  description = "For more information and documentation, see the source repository at GitHub."
  value       = "https://github.com/opsline/rds-snapshot-tool"
}
