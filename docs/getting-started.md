# Getting Started

## Prerequisites

- Terraform >= 1.5
- AWS provider >= 5.20
- Three AWS accounts (or at minimum, three provider configurations):
    - **Principal account**: where the GitHub OIDC provider is configured
    - **CI/CD account**: where the IAM roles are created
    - **TF States account**: where the S3 bucket and DynamoDB table are created
- A GitHub organization and repository

## First Deployment

### 1. Configure Providers

Set up three AWS provider aliases in your root module:

```hcl
provider "aws" {
  alias  = "principal"
  region = "us-west-2"
}

provider "aws" {
  alias  = "cicd"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::CICD_ACCOUNT_ID:role/admin"
  }
}

provider "aws" {
  alias  = "tfstates"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::TFSTATES_ACCOUNT_ID:role/admin"
  }
}
```

### 2. Add the Module

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

### 3. Apply

```bash
terraform init
terraform plan
terraform apply
```

### 4. Configure the Target Repository

After applying, use the outputs to configure the target repository's GitHub Actions workflow
and Terraform backend:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-org-my-repo-state"
    key            = "terraform.tfstate"
    dynamodb_table = "my-org-my-repo-state-locks"
    region         = "us-west-2"
  }
}
```

## Next Steps

- Review the [Configuration](configuration.md) page for all available options
- See [Architecture](architecture.md) for how the IAM role chain works
- Check [Examples](examples.md) for common use cases
