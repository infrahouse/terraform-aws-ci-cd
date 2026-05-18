# Architecture

## How It Works

The module creates a secure IAM role chain that allows GitHub Actions to perform Terraform
operations across multiple AWS accounts.

## Role Chain

```
GitHub Actions (OIDC)
    |
    v
ih-tf-{repo}-github  (CI/CD account)
    |
    +---> ih-tf-{repo}-admin          (CI/CD account)
    |       - Performs terraform apply
    |       - Has configurable policy (default: AdministratorAccess)
    |
    +---> ih-tf-{repo}-state-manager  (CI/CD account)
            - Reads/writes Terraform state
            - Access to S3 bucket and DynamoDB table
```

## Multi-Account Setup

The module requires three AWS provider aliases to support a multi-account architecture:

| Provider | Purpose | Resources Created |
|----------|---------|-------------------|
| `aws` | Principal account | GitHub OIDC provider trust |
| `aws.cicd` | CI/CD account | IAM roles (`-github`, `-admin`, `-state-manager`) |
| `aws.tfstates` | State storage account | S3 bucket, DynamoDB lock table |

This separation follows the principle of least privilege: CI/CD roles live in a dedicated account,
and state storage is isolated in its own account.

## Submodules

### gha-admin

Creates the three IAM roles with proper trust relationships:

- The `-github` role trusts the GitHub OIDC provider for the specified org/repo
- The `-admin` role trusts the `-github` role (and any `trusted_arns`)
- The `-state-manager` role trusts the `-github` role (and any `trusted_arns`)
- The `-github` role can assume both `-admin` and `-state-manager` (and any `allowed_arns`)

### state-bucket

Creates the Terraform state backend:

- S3 bucket with encryption enabled
- DynamoDB table for state locking
- Tagged with `used_by` to track which repository uses the state

## Security Considerations

- GitHub OIDC eliminates the need for long-lived AWS credentials in GitHub
- Role chaining limits the blast radius of any single credential compromise
- State bucket encryption protects sensitive values in Terraform state
- DynamoDB locking prevents concurrent state modifications
