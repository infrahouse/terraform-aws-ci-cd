# Examples

## Basic Usage

Create CI/CD resources for a single repository:

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

## Restricted Admin Policy

Use a less-privileged policy instead of `AdministratorAccess`:

```hcl
module "my-repo-cicd" {
  source  = "infrahouse/ci-cd/aws"
  version = "1.0.4"

  providers = {
    aws          = aws.principal
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tfstates
  }

  gh_org            = "my-org"
  gh_repo           = "my-repo"
  state_bucket      = "my-org-my-repo-state"
  admin_policy_name = "PowerUserAccess"
}
```

## Additional Trusted Roles

Allow a break-glass role to assume the admin and state-manager roles:

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

  trusted_arns = [
    "arn:aws:iam::123456789012:role/break-glass-admin"
  ]
}
```

## Multiple Repositories

Bootstrap CI/CD for several repositories in the same organization:

```hcl
locals {
  repos = {
    "infra-core"     = "my-org-infra-core-state"
    "app-deploy"     = "my-org-app-deploy-state"
    "github-control" = "my-org-github-control-state"
  }
}

module "cicd" {
  for_each = local.repos
  source   = "infrahouse/ci-cd/aws"
  version  = "1.0.4"

  providers = {
    aws          = aws.principal
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tfstates
  }

  gh_org       = "my-org"
  gh_repo      = each.key
  state_bucket = each.value
}
```
