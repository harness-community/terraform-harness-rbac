####################
#
# Harness Resource Group Validations
#
####################
locals {
  resource_group_outputs = flatten([
    {
      minimum               = module.resource_groups_minimal.resource_group_details
      minimal_org_level     = module.resource_groups_minimal_org_level.resource_group_details
      minimal_account_level = module.resource_groups_minimal_account_level.resource_group_details
      custom_scope_single   = module.resource_groups_custom_scope_single.resource_group_details
      custom_scope          = module.resource_groups_custom_scope.resource_group_details
      custom_scope_project  = module.resource_groups_custom_scope_project.resource_group_details
      custom_scope_org      = module.resource_groups_custom_scope_org.resource_group_details
    }
  ])
}

module "resource_groups_minimal" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "test-resource-group-minimal"
  organization_id          = local.organization_id
  project_id               = local.project_id
  global_tags              = local.common_tags

}
module "resource_groups_minimal_org_level" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "${local.organization_id}-test-resource-group-minimal"
  organization_id          = local.organization_id
  global_tags              = local.common_tags

}
module "resource_groups_minimal_account_level" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "${local.organization_id}-test-resource-group-minimal"
  global_tags              = local.common_tags

}

module "resource_groups_custom_scope_single" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "${local.organization_id}-test-resource-group-custom-scope-single"
  resource_group_scopes = [{
    filter = "INCLUDING_CHILD_SCOPES"
  }]
  global_tags = local.common_tags

}
module "resource_groups_custom_scope" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "${local.organization_id}-test-resource-group-custom-scope-multiple"
  organization_id          = local.organization_id
  project_id               = local.project_id
  resource_group_scopes = [
    {
      filter          = "EXCLUDING_CHILD_SCOPES"
      organization_id = local.organization_id
      project_id      = local.project_id
    }
  ]
  global_tags = local.common_tags

}
module "resource_groups_custom_scope_project" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "${local.organization_id}-test-resource-group-custom-scope-multiple-project"
  organization_id          = local.organization_id
  resource_group_scopes = [
    {
      filter          = "EXCLUDING_CHILD_SCOPES"
      organization_id = local.organization_id
      project_id      = local.project_id
    },
    {
      filter          = "EXCLUDING_CHILD_SCOPES"
      organization_id = local.organization_id
      project_id      = local.project_secondary_id
    }
  ]
  global_tags = local.common_tags

}
module "resource_groups_custom_scope_org" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "${local.organization_id}-test-resource-group-custom-scope-multiple-org"
  resource_group_scopes = [
    {
      filter          = "EXCLUDING_CHILD_SCOPES"
      organization_id = local.organization_id
      project_id      = local.project_id
    },
    {
      filter          = "INCLUDING_CHILD_SCOPES"
      organization_id = local.organization_secondary_id
    }
  ]
  global_tags = local.common_tags

}

module "resource_groups_resource_filters" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "test-resource-group-resource-filters"
  organization_id          = local.organization_id
  project_id               = local.project_id
  global_tags              = local.common_tags
  resource_group_filters = [
    {
      type = "PIPELINE"
    }
  ]
}
module "resource_groups_resource_filter_with_identifiers" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  identifier               = "test_resource_group_resource_filter_identifier"
  name                     = "test-resource-group-resource-filter-identifier"
  organization_id          = local.organization_id
  project_id               = local.project_id
  global_tags              = local.common_tags
  resource_group_filters = [
    {
      type = "RESOURCEGROUP"
      identifiers = [
        "test_resource_group_resource_filters"
      ]
    }
  ]
}
module "resource_groups_resource_filter_with_filters" {

  source = "../../modules/resource_groups"

  harness_platform_account = var.harness_platform_account
  name                     = "test-resource-group-resource-filter-with-filters"
  organization_id          = local.organization_id
  project_id               = local.project_id
  global_tags              = local.common_tags
  resource_group_filters = [
    {
      type = "ENVIRONMENT"
      filters = [
        {
          name = "type"
          values = [
            "PreProduction"
          ]
        }
      ]
    },
    {
      type = "CONNECTOR"
      filters = [
        {
          name   = "category"
          values = "CLOUD_PROVIDER, SECRET_MANAGER"
        }
      ]
    }
  ]

}
