####################
#
# Harness User Groups Validations
#
####################
locals {
  user_group_outputs = flatten([
    {
      test                = true
      minimum             = module.user_groups_minimal.details
      minimal_org         = module.user_groups_minimal_org.details
      minimal_account     = module.user_groups_minimal_account.details
      email_membership    = module.user_groups_email_membership.details
      username_membership = module.user_groups_username_membership.details
      role_binding        = module.user_groups_role_binding.details
    }
  ])
}

module "user_groups_minimal" {

  source = "../../modules/user_groups"

  name            = "test-user-group-minimal"
  organization_id = local.organization_id
  project_id      = local.project_id
  global_tags     = local.common_tags

}

module "user_groups_minimal_org" {

  source = "../../modules/user_groups"

  name            = "test-user-group-minimal-org"
  organization_id = local.organization_id
  global_tags     = local.common_tags

}

module "user_groups_minimal_account" {

  source = "../../modules/user_groups"

  name        = "${local.organization_id}-test-user-group-minimal-account"
  global_tags = local.common_tags

}

module "user_groups_email_membership" {

  source = "../../modules/user_groups"

  name                 = "test-user-group-with-email"
  organization_id      = local.organization_id
  project_id           = local.project_id
  user_email_addresses = ["test-terraform-harness-rbac@harness.io"]
  global_tags          = local.common_tags

}

module "user_groups_username_membership" {

  source = "../../modules/user_groups"

  name            = "test-user-group-with-username"
  organization_id = local.organization_id
  project_id      = local.project_id
  user_names      = ["test-terraform-harness-rbac"]
  global_tags     = local.common_tags

}

module "user_groups_role_binding" {

  source = "../../modules/user_groups"

  name              = "test-user-group-with-role-binding"
  organization_id   = local.organization_id
  project_id        = local.project_id
  role_id           = "_project_admin"
  resource_group_id = "_all_project_level_resources"
  global_tags       = local.common_tags

}

module "user_groups_no_role_binding" {

  source = "../../modules/user_groups"

  name              = "test-user-group-without-role-binding"
  organization_id   = local.organization_id
  project_id        = local.project_id
  role_id           = "_project_admin"
  resource_group_id = "_all_project_level_resources"
  has_binding       = false
  global_tags       = local.common_tags

}
