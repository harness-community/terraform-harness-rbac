####################
#
# Harness User Group Setup
#
####################

resource "harness_platform_usergroup" "group" {
  lifecycle {
    precondition {
      condition     = !(length(var.user_email_addresses) > 0 && length(var.user_names) > 0)
      error_message = <<EOF
      [Error] Either provide list of users or list of user emails.
      EOF
    }
  }
  # [Required] (String) Unique identifier of the resource.
  identifier = local.fmt_identifier
  # [Optional] (String) Name of the user.
  name = var.name

  # (String) Description of the resource.
  description = var.description

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id

  # # (Boolean) Whether the user group is externally managed.
  # externally_managed = var.externally_managed
  # # (String) Name of the linked SSO.
  # linked_sso_display_name = var.linked_sso_display_name
  # # (String) The SSO account ID that the user group is linked to.
  # linked_sso_id = var.linked_sso_id
  # # (String) Type of linked SSO.
  # linked_sso_type = var.linked_sso_type
  # # (Block List) List of notification settings. (see below for nested schema)
  # notification_configs = var.notification_configs

  # # (String) Identifier of the userGroup in SSO.
  # sso_group_id = var.sso_group_id
  # # (String) Name of the SSO userGroup.
  # sso_group_name = var.sso_group_name
  # # (Boolean) Whether sso is linked or not.
  # sso_linked = var.sso_linked

  # (List of String) List of user emails in the UserGroup. Either provide list of users or list of user emails.
  user_emails = length(var.user_email_addresses) > 0 ? var.user_email_addresses : null
  # (List of String) List of users in the UserGroup. Either provide list of users or list of user emails.
  users = length(var.user_names) > 0 ? var.user_names : null

  # [Optional] (Set of String) Tags to associate with the resource.
  tags = local.common_tags
}

resource "harness_platform_role_assignments" "binding" {
  lifecycle {
    precondition {
      condition     = local.binding_validation
      error_message = <<EOF
      [Invalid] The following variables need to be passed with valid values to create a binding
      - resource_group_id
      - role_id
      EOF
    }
  }
  count = (
    var.resource_group_id != null && var.role_id != null
    ?
    1
    :
    0
  )
  # [Required] (String) Unique identifier of the resource.
  identifier = local.fmt_identifier

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id

  # [Optional] (String) Resource group identifier.
  resource_group_identifier = var.resource_group_id

  # [Optional] (String) Role identifier.
  role_identifier = var.role_id

  principal {
    identifier  = harness_platform_usergroup.group.id
    scope_level = local.allowed_scope_levels
    type        = "USER_GROUP"
  }

  # [Optional] (Boolean) Disabled or not.
  disabled = var.is_enabled ? false : true

  # [Optional] (Boolean) Managed or not.
  managed = var.is_managed
}
