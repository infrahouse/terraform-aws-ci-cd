output "github-role" {
  description = "ARN of the `ih-tf-{var.repo_name}-github` role"
  value       = module.gha-admin.github_role_arn
}

output "admin-role" {
  description = "ARN of the `ih-tf-{var.repo_name}-admin` role"
  value       = module.gha-admin.admin_role_arn
}

output "state-manager-role" {
  description = "ARN of the `ih-tf-{var.repo_name}-state-manager` role"
  value       = module.gha-admin.state_manager_role_arn
}

output "bucket_name" {
  description = "Name of the created S3 bucket."
  value       = module.state-bucket.bucket_name
}

output "lock_table_name" {
  description = "Name of the created DynamoDB table for state locks."
  value       = module.state-bucket.lock_table_name
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket."
  value       = module.state-bucket.bucket_arn
}

output "lock_table_arn" {
  description = "ARN of the created DynamoDB table for state locks."
  value       = module.state-bucket.lock_table_arn
}
