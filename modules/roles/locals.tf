####################
#
# Harness Role Local Variables
#
####################
locals {
  required_tags = [
    "created_by:Terraform"
  ]
  # Harness Tags are read into Terraform as a standard Map entry but needs to be
  # converted into a list of key:value entries
  global_tags = [for k, v in var.global_tags : "${k}:${v}"]
  # Harness Tags are read into Terraform as a standard Map entry but needs to be
  # converted into a list of key:value entries
  tags = [for k, v in var.tags : "${k}:${v}"]

  common_tags = flatten([
    local.tags,
    local.global_tags,
    local.required_tags
  ])

  auto_identifier = (
        replace(
          replace(
            var.name,
            " ",
            "_"
          ),
          "-",
          "_"
        )
  )

  fmt_identifier = (
    var.identifier == null
    ?
    (
      var.case_sensitive
      ?
      local.auto_identifier
      :
      lower(local.auto_identifier)
    )
    :
    var.identifier
  )

  # Set the allowed scope levels based on the provided
  # details for where the resource group will be created.
  allowed_scope_levels = flatten([
    var.project_id != null
    ?
    "project"
    :
    var.organization_id != null
    ?
    "organization"
    :
    "account"
  ])

  permission_statuses = [
    "ACTIVE",
    "EXPERIMENTAL"
  ]

  # ~ ROLE MANAGEMENT ~
  # Generate Local lists of all permissions and their scope
  global_permission_identifiers = sort(compact(flatten([
    for permission in data.harness_platform_permissions.current.permissions : [
      permission.identifier
    ] if contains(local.permission_statuses, permission.status)
  ])))

  organization_permission_identifiers = sort(compact(flatten([
    for permission in data.harness_platform_permissions.current.permissions : [
      permission.identifier
    ] if contains(local.permission_statuses, permission.status) && contains(permission.allowed_scope_levels, "organization")
  ])))

  project_permission_identifiers = sort(compact(flatten([
    for permission in data.harness_platform_permissions.current.permissions : [
      permission.identifier
    ] if contains(local.permission_statuses, permission.status) && contains(permission.allowed_scope_levels, "project")
  ])))

  invalid_global_permissions = compact(flatten([
    for permission in var.role_permissions : [
      permission
    ] if !contains(local.global_permission_identifiers, permission)
  ]))
  invalid_organization_permissions = compact(flatten([
    for permission in var.role_permissions : [
      permission
    ] if !contains(local.organization_permission_identifiers, permission)
  ]))
  invalid_project_permissions = compact(flatten([
    for permission in var.role_permissions : [
      permission
    ] if !contains(local.project_permission_identifiers, permission)
  ]))

  permission_validation = (
    var.organization_id == null && var.project_id == null
    ?
    length(local.invalid_global_permissions) > 0
    ?
    local.invalid_global_permissions
    :
    []
    :
    (
      var.organization_id != null && var.project_id == null
      ?
      length(local.invalid_organization_permissions) > 0
      ?
      local.invalid_organization_permissions
      :
      []
      :
      (
        var.project_id != null
        ?
        length(local.invalid_project_permissions) > 0
        ?
        local.invalid_project_permissions
        :
        []
        :
        []
      )
    )
  )

}
