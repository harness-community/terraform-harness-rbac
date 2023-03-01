# Depends on
# - harness_resource_groups.tf
# - harness_roles.tf
# - harness_user_groups.tf
# - harness_user_accounts.tf

# Create Testing infrastructure
resource "harness_platform_organization" "test" {
  identifier  = "${local.fmt_prefix}_terraform_harness_rbac"
  name        = "${local.fmt_prefix}-terraform-harness-rbac"
  description = "Testing Organization for Terraform Harness RBAC"
  tags        = ["purpose:terraform-testing"]
}

resource "harness_platform_organization" "secondary" {
  identifier  = "${local.fmt_prefix}_terraform_harness_rbac_2nd"
  name        = "${local.fmt_prefix}-terraform-harness-rbac-2nd"
  description = "Testing Organization for Terraform Harness RBAC"
  tags        = ["purpose:terraform-testing"]
}

resource "harness_platform_project" "test" {
  identifier = "terraform_harness_rbac"
  name       = "terraform-harness-rbac"
  org_id     = harness_platform_organization.test.id
  color      = "#0063F7"
  tags       = ["purpose:terraform-testing"]
}

resource "harness_platform_project" "secondary" {
  identifier = "terraform_harness_rbac_2nd"
  name       = "terraform-harness-rbac-2nd"
  org_id     = harness_platform_organization.test.id
  color      = "#0063F7"
  tags       = ["purpose:terraform-testing"]
}
