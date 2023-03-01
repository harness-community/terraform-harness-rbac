####################
#
# Harness User Account Setup
#
####################

data "harness_platform_resource_group" "select" {
  for_each = {
    for role in var.role_bindings : (role.resource_group_id) => role
  }
  identifier = each.value.resource_group_id

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id
}

data "harness_platform_roles" "select" {
  for_each = {
    for role in var.role_bindings : (role.role_id) => role
  }
  identifier = each.value.role_id

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id
}

resource "harness_platform_user" "user" {
  # lifecycle {
  #   precondition {
  #     condition     = !(length(var.user_email_addresses) > 0 && length(var.user_names) > 0)
  #     error_message = <<EOF
  #     [Error] Either provide list of users or list of user emails.
  #     EOF
  #   }
  # }

  # [Required] (String) The email of the user.
  email = var.email_address

  # [Required] (Set of String) The user group of the user. Cannot be updated.
  user_groups = var.user_groups

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id


  # [Required] (Block List, Min: 1) Role Bindings of the user. (see below for nested schema)
  dynamic "role_bindings" {
    for_each = var.role_bindings
    content {
      # (Boolean) Managed Role of the user.
      managed_role = lookup(role_bindings.value, "managed_role", true)
      # (String) Resource Group Identifier of the user.
      resource_group_identifier = data.harness_platform_resource_group.select[role_bindings.value.resource_group_id].id
      # (String) Resource Group Name of the user.
      resource_group_name = data.harness_platform_resource_group.select[role_bindings.value.resource_group_id].name
      # (String) Role Identifier of the user.
      role_identifier = data.harness_platform_roles.select[role_bindings.value.role_id].id
      # (String) Role Name Identifier of the user
      role_name = data.harness_platform_roles.select[role_bindings.value.role_id].name
    }
  }
}
