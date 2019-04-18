output "copy_failed_topic" {
  description = "Subscribe to this topic to receive alerts of failed copies"
  value       = ["${aws_sns_topic.rds_copy_failed_dest_topic.arn}"]
}

output "delete_old_dest_failed_topic" {
  description = "Subscribe to this topic to receive alerts of failures at deleting old destination snapshots"
  value       = ["${aws_sns_topic.rds_delete_old_failed_dest_topic.arn}"]
}

output "source_url" {
  description = "For more information and documentation, see the source repository at GitHub."
  value       = "https://github.com/opsline/rds-snapshot-tool"
}
