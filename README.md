# terraform-aws-ci-cd

Bootstrap Terraform CI/CD for any GitHub repository.

[![Need Help?](https://img.shields.io/badge/Need%20Help%3F-Contact%20Us-0066CC)](https://infrahouse.com/contact)
[![Docs](https://img.shields.io/badge/docs-github.io-blue)](https://infrahouse.github.io/terraform-aws-ci-cd/)
[![Registry](https://img.shields.io/badge/Terraform-Registry-purple?logo=terraform)](https://registry.terraform.io/modules/infrahouse/ci-cd/aws/latest)
[![Release](https://img.shields.io/github/release/infrahouse/terraform-aws-ci-cd.svg)](https://github.com/infrahouse/terraform-aws-ci-cd/releases/latest)
[![AWS IAM](https://img.shields.io/badge/AWS-IAM-orange?logo=amazoniam)](https://aws.amazon.com/iam/)
[![AWS S3](https://img.shields.io/badge/AWS-S3-orange?logo=amazons3)](https://aws.amazon.com/s3/)
[![AWS DynamoDB](https://img.shields.io/badge/AWS-DynamoDB-orange?logo=amazondynamodb)](https://aws.amazon.com/dynamodb/)
[![Security](https://img.shields.io/github/actions/workflow/status/infrahouse/terraform-aws-ci-cd/vuln-scanner-pr.yml?label=Security)](https://github.com/infrahouse/terraform-aws-ci-cd/actions/workflows/vuln-scanner-pr.yml)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

This module creates all the resources needed to enable Terraform CI/CD in a GitHub repository:

- **Three IAM roles** (`-github`, `-admin`, `-state-manager`) via the
  [gha-admin](https://registry.terraform.io/modules/infrahouse/gha-admin/aws/latest) submodule
- **S3 state bucket + DynamoDB lock table** via the
  [state-bucket](https://registry.terraform.io/modules/infrahouse/state-bucket/aws/latest) submodule

## Why This Module?

Setting up Terraform CI/CD for a GitHub repository requires creating IAM roles with
OIDC trust, an S3 state bucket, and a DynamoDB lock table -- spread across multiple
AWS accounts. This module does it all in one call with sensible, secure defaults.

## Features

- Single module call to bootstrap complete Terraform CI/CD
- Secure IAM role chain: GitHub OIDC -> `-github` -> `-admin` / `-state-manager`
- Encrypted S3 state bucket with DynamoDB locking
- Multi-account support via three provider aliases
- Configurable admin policy (default: `AdministratorAccess`)
- Support for additional trusted and allowed ARNs

## Quick Start

```hcl
module "my-repo-cicd" {
  source  = "infrahouse/ci-cd/aws"
  version = "1.0.4"

  providers = {
    aws          = aws.principal
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tfstates
  }

  gh_org       = "my-org"
  gh_repo      = "my-repo"
  state_bucket = "my-org-my-repo-state"
}
```

## Documentation

Full documentation is available at
[infrahouse.github.io/terraform-aws-ci-cd](https://infrahouse.github.io/terraform-aws-ci-cd/):

- [Getting Started](https://infrahouse.github.io/terraform-aws-ci-cd/getting-started/)
- [Architecture](https://infrahouse.github.io/terraform-aws-ci-cd/architecture/)
- [Configuration](https://infrahouse.github.io/terraform-aws-ci-cd/configuration/)
- [Examples](https://infrahouse.github.io/terraform-aws-ci-cd/examples/)
- [Troubleshooting](https://infrahouse.github.io/terraform-aws-ci-cd/troubleshooting/)

## Usage

<!-- BEGIN_TF_DOCS -->

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
<!-- END_TF_DOCS -->

## Examples

See the [examples/](examples/) directory for working configurations.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

Apache 2.0 -- see [LICENSE](LICENSE) for details.
