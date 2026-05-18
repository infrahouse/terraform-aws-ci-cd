# terraform-aws-ci-cd

A Terraform module that creates all the resources needed to enable Terraform CI/CD for a GitHub repository.

## Overview

This module provisions:

- **Three IAM roles** via the
  [gha-admin](https://registry.terraform.io/modules/infrahouse/gha-admin/aws/latest) submodule:
    - `-github` role: assumed by GitHub Actions workflows
    - `-admin` role: performs Terraform apply operations
    - `-state-manager` role: manages Terraform state read/write
- **State backend** via the
  [state-bucket](https://registry.terraform.io/modules/infrahouse/state-bucket/aws/latest) submodule:
    - S3 bucket for Terraform state storage
    - DynamoDB table for state locking

## Features

- Single module to bootstrap complete Terraform CI/CD for any GitHub repository
- Secure IAM role chain: GitHub OIDC -> `-github` -> `-admin` / `-state-manager`
- Encrypted S3 state bucket with DynamoDB locking
- Multi-account support via provider aliases (`aws`, `aws.cicd`, `aws.tfstates`)
- Configurable admin policy and trusted/allowed ARNs

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

See [Getting Started](getting-started.md) for a full walkthrough.
