# Troubleshooting

## Common Issues

### "Error assuming role" in GitHub Actions

**Symptom:** GitHub Actions workflow fails with an error like
`Error: Could not assume role with OIDC`.

**Cause:** The GitHub OIDC provider trust relationship doesn't match the repository.

**Fix:** Verify that `gh_org` and `gh_repo` match exactly (case-sensitive) with the GitHub
organization and repository names.

### State Lock Timeout

**Symptom:** `Error acquiring the state lock` when running Terraform.

**Cause:** A previous Terraform run didn't release the DynamoDB lock, or another run
is in progress.

**Fix:**

1. Check if another Terraform run is active
2. If not, force-unlock: `terraform force-unlock LOCK_ID`

### S3 Bucket Already Exists

**Symptom:** `BucketAlreadyExists` or `BucketAlreadyOwnedByYou` error.

**Cause:** The `state_bucket` name is globally unique in S3. Another account or module
already created a bucket with this name.

**Fix:** Choose a unique bucket name. A common pattern is
`{org}-{repo}-state` (e.g., `my-org-my-repo-state`).

### Permission Denied on Terraform Apply

**Symptom:** `AccessDenied` errors during `terraform apply` in the target repository.

**Cause:** The `-admin` role's policy doesn't grant the required permissions.

**Fix:** By default, the role has `AdministratorAccess`. If you've set
`admin_policy_name` to a more restrictive policy, ensure it covers all resources
your Terraform configuration manages.

### Provider Alias Mismatch

**Symptom:** `Error: No configuration for provider` or resources created in the
wrong account.

**Cause:** The `providers` block in the module call doesn't correctly map the
three required aliases.

**Fix:** Ensure your module call includes all three provider mappings:

```hcl
providers = {
  aws          = aws.principal    # Principal account
  aws.cicd     = aws.cicd         # CI/CD account
  aws.tfstates = aws.tfstates     # State storage account
}
```
