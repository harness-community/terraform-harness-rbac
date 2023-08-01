####################
#
# Harness Roles Validations
#
####################
locals {
  role_outputs = flatten([
    {
      minimum            = module.roles_minimal.details
      minimal_org        = module.roles_minimal_org.details
      minimal_account    = module.roles_minimal_account.details
      custom_permissions = module.roles_minimal_custom_permissions.details
    }
  ])
}

module "roles_minimal" {

  source = "../../modules/roles"

  name            = "test-role-minimal"
  organization_id = local.organization_id
  project_id      = local.project_id
  global_tags     = local.common_tags

}

module "roles_minimal_org" {

  source = "../../modules/roles"

  name            = "test-role-minimal-org"
  organization_id = local.organization_id
  global_tags     = local.common_tags

}

module "roles_minimal_account" {

  source = "../../modules/roles"

  name        = "${local.organization_id}-test-role-minimal-account"
  global_tags = local.common_tags

}

module "roles_minimal_custom_permissions" {

  source = "../../modules/roles"

  name             = "test-role-custom-permissions"
  organization_id  = local.organization_id
  project_id       = local.project_id
  role_permissions = ["core_environment_access", "core_connector_access"]
  global_tags      = local.common_tags

}
