# Configuration

## Required Variables

### gh_org

GitHub organization name.

```hcl
gh_org = "my-org"
```

### gh_repo

Repository name in GitHub, without the organization part.

```hcl
gh_repo = "my-repo"
```

### state_bucket

Name of S3 bucket for Terraform state. The module will create it.

```hcl
state_bucket = "my-org-my-repo-state"
```

## Optional Variables

### admin_policy_name

Name of the IAM policy the `-admin` role will have. This controls what Terraform can do
when running `apply`.

- **Type:** `string`
- **Default:** `"AdministratorAccess"`

```hcl
admin_policy_name = "PowerUserAccess"
```

### allowed_arns

A list of additional ARNs that the `-github` role is allowed to assume, besides the
`-admin` and `-state-manager` roles.

- **Type:** `list(string)`
- **Default:** `[]`

```hcl
allowed_arns = [
  "arn:aws:iam::123456789012:role/custom-deploy-role"
]
```

### trusted_arns

A list of additional ARNs that are allowed to assume the `-admin` and `-state-manager`
roles, besides the `-github` role.

- **Type:** `list(string)`
- **Default:** `[]`

```hcl
trusted_arns = [
  "arn:aws:iam::123456789012:role/break-glass-role"
]
```

## Outputs

| Output | Description |
|--------|-------------|
| `github-role` | ARN of the `-github` role |
| `admin-role` | ARN of the `-admin` role |
| `state-manager-role` | ARN of the `-state-manager` role |
| `bucket_name` | Name of the created S3 bucket |
| `bucket_arn` | ARN of the created S3 bucket |
| `lock_table_name` | Name of the DynamoDB lock table |
| `lock_table_arn` | ARN of the DynamoDB lock table |

## Provider Configuration

The module requires three provider aliases:

```hcl
providers = {
  aws          = aws.principal    # Principal account
  aws.cicd     = aws.cicd         # CI/CD account (IAM roles)
  aws.tfstates = aws.tfstates     # State storage account (S3 + DynamoDB)
}
```
