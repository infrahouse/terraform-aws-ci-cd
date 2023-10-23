# Module terraform-aws-ci-cd

[ci-cd on Terraform Registry](https://registry.terraform.io/modules/infrahouse/ci-cd/aws/latest).

The module creates necessary resources to enable Terraform CI/CD in a Terraform root module.

The resources are:
* Three IAM roles: "-github", "-admin", "-state-manager".
 See the [gha-admin](https://registry.terraform.io/modules/infrahouse/gha-admin/aws/latest) module for details.
* S3 bucket and DynamoDB table for state locks.
  See the [state-bucket](https://registry.terraform.io/modules/infrahouse/state-bucket/aws/latest) module for details.

## Usage

Let's say there is a repo [github-control](https://github.com/infrahouse8/github-control)
 in a GitHub organization [infrahouse8](https://github.com/infrahouse8).

Then, to create CI/CD resources include this module.

```hcl

module "infrahouse8-github-control" {
  source  = "infrahouse/ci-cd/aws"
  version = "~> 1.0"

  providers = {
    aws          = aws.principal-account
    aws.cicd     = aws.ci-cd-account
    aws.tfstates = aws.tf-states-account
  }

  gh_org       = "infrahouse"
  gh_repo      = "github-control"
  state_bucket = "infrahouse-github-control-state"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.20 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gha-admin"></a> [gha-admin](#module\_gha-admin) | infrahouse/gha-admin/aws | ~> 3.2 |
| <a name="module_state-bucket"></a> [state-bucket](#module\_state-bucket) | infrahouse/state-bucket/aws | ~> 2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_policy_name"></a> [admin\_policy\_name](#input\_admin\_policy\_name) | Name of the IAM policy the `ih-tf-{var.repo_name}-admin` role will have. This is what the role can do. | `string` | `"AdministratorAccess"` | no |
| <a name="input_allowed_arns"></a> [allowed\_arns](#input\_allowed\_arns) | A list of ARNs `ih-tf-{var.repo_name}-github` is allowed to assume besides `ih-tf-{var.repo_name}-admin` and `ih-tf-{var.repo_name}-state-manager` roles. | `list(string)` | `[]` | no |
| <a name="input_gh_org"></a> [gh\_org](#input\_gh\_org) | GitHub organization name. | `string` | n/a | yes |
| <a name="input_gh_repo"></a> [gh\_repo](#input\_gh\_repo) | Repository name in GitHub. Without the organization part. | `string` | n/a | yes |
| <a name="input_state_bucket"></a> [state\_bucket](#input\_state\_bucket) | Name of S3 bucket for Terraform state. The module will create it. | `string` | n/a | yes |
| <a name="input_trusted_arns"></a> [trusted\_arns](#input\_trusted\_arns) | A list of ARNs besides `ih-tf-{var.repo_name}-github` that are allowed to assume the `ih-tf-{var.repo_name}-admin` and `ih-tf-{var.repo_name}-state-manager` role. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin-role"></a> [admin-role](#output\_admin-role) | ARN of the `ih-tf-{var.repo_name}-admin` role |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the created S3 bucket. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the created S3 bucket. |
| <a name="output_github-role"></a> [github-role](#output\_github-role) | ARN of the `ih-tf-{var.repo_name}-github` role |
| <a name="output_lock_table_arn"></a> [lock\_table\_arn](#output\_lock\_table\_arn) | ARN of the created DynamoDB table for state locks. |
| <a name="output_lock_table_name"></a> [lock\_table\_name](#output\_lock\_table\_name) | Name of the created DynamoDB table for state locks. |
| <a name="output_state-manager-role"></a> [state-manager-role](#output\_state-manager-role) | ARN of the `ih-tf-{var.repo_name}-state-manager` role |
