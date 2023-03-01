####################
#
# Harness Role Setup
#
####################
data "harness_platform_permissions" "current" {
}

resource "harness_platform_roles" "role" {
  lifecycle {
    precondition {
      condition     = length(local.permission_validation) == 0
      error_message = <<EOF
      [Invalid] The following permissions are invalid for this scope.
      - ${join("\n      - ", local.permission_validation)}
      EOF
    }
  }
  # [Required] (String) Unique identifier of the resource.
  identifier = local.fmt_identifier

  # [Required] (String) Name of the resource.
  name = var.name
  # [Optional] (String) Description of the resource.
  description = var.description

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id

  # [Optional] (Set of String) The scope levels at which this role can be used
  # allowed_scope_levels = var.allowed_scope_levels
  allowed_scope_levels = local.allowed_scope_levels
  # [Optional] (Set of String) List of the permission identifiers
  #
  # Note: Full list of current and valid permissions can be found here
  # https://app.harness.io/gateway/authz/api/permissions
  # API Docs - https://apidocs.harness.io/tag/Permissions#operation/getPermissionList
  permissions = var.role_permissions != [] ? var.role_permissions : null

  # [Optional] (Set of String) Tags to associate with the resource.
  tags = local.common_tags
}
