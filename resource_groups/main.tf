####################
#
# Harness Resource Group Setup
#
####################
# Allows for automatic color selection for resources when
# var.color is not provided.
resource "random_id" "color_picker" {
  keepers = {
    # Generate a new id each time we switch to a new resource id
    identifier = local.fmt_identifier
  }

  byte_length = 3
}

resource "harness_platform_resource_group" "rg" {
  lifecycle {
    precondition {
      condition     = local.verify_scopes.message == "success"
      error_message = "[Invalid] ${local.verify_scopes.message}\n ${jsonencode(local.verify_scopes.invalid_scopes)}"
    }
  }
  # [Required] (String) Account Identifier of the account
  account_id = var.harness_platform_account
  # [Required] (String) Unique identifier of the resource.
  identifier = local.fmt_identifier

  # [Required] (String) Name of the resource.
  name = var.name
  # [Optional] (String) Description of the resource.
  description = var.description
  # [Optional] (String) Color of the environment.
  color = var.color != null ? var.color : "#${random_id.color_picker.hex}"

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id

  # [Optional] (Set of String) The scope levels at which this resource group can be used
  # allowed_scope_levels = var.allowed_scope_levels
  allowed_scope_levels = local.allowed_scope_levels

  # [Optional] (Block Set) Included scopes (see below for nested schema)
  dynamic "included_scopes" {
    for_each = var.resource_group_scopes
    content {
      # (String) Can be one of these 2 EXCLUDING_CHILD_SCOPES or INCLUDING_CHILD_SCOPES
      filter = lookup(included_scopes.value, "filter", "INCLUDING_CHILD_SCOPES")
      # (String) Account Identifier of the account
      account_id = var.harness_platform_account
      # (String) Organization Identifier
      org_id = lookup(included_scopes.value, "organization_id", null)
      # (String) Project Identifier
      project_id = lookup(included_scopes.value, "project_id", null)
    }
  }

  # # [Optional] (Block List) Contains resource filter for a resource group (see below for nested schema)
  # resource_filter = var.resource_filter
  resource_filter {
    # (Boolean) Include all resource or not
    include_all_resources = var.resource_group_filters != [] ? false : true
    dynamic "resources" {
      for_each = var.resource_group_filters
      content {
        resource_type = lookup(resources.value, "type", null)
        # (Set of String) List of the identifiers
        identifiers = lookup(resources.value, "identifiers", null)
        dynamic "attribute_filter" {
          for_each = lookup(resources.value, "filters", [])
          content {
            # (String) Name of the attribute
            attribute_name = lookup(attribute_filter.value, "name", null)
            # (Set of String) Value of the attributes
            attribute_values = flatten([
              try(
                flatten([
                  for value in split(",",lookup(attribute_filter.value, "values", "")) : [
                    trimspace(value)
                  ]
                ]),
                flatten([lookup(attribute_filter.value, "values", [])])
              )
            ])
          }
        }
      }
    }
  }
  # [Optional] (Set of String) Tags to associate with the resource.
  tags = local.common_tags
}
