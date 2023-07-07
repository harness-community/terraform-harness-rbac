####################
#
# Harness Resource Group Local Variables
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

  # Scan all resource_group_scopes for any that
  # do not include the project_id
  project_scopes = flatten([
    for scope in var.resource_group_scopes : [
      scope
    ] if lookup(scope, "project_id", null) != var.project_id
  ])
  # Scan all resource_group_scopes for any that
  # do not include the organization_id
  organization_scopes = flatten([
    for scope in var.resource_group_scopes : [
      scope
    ] if lookup(scope, "organization_id", null) != var.organization_id
  ])

  # After finding the list of scopes that might not be scoped correctly,
  # generate a new local variable that contains the information for the
  # precondition on the resource group.
  verify_scopes = (
    var.project_id != null
    ?
    length(local.project_scopes) > 0
    ?
    {
      message        = "Invalid scopes assigned to Resource Group scoped to Project level"
      invalid_scopes = local.project_scopes
    }
    :
    {
      message        = "success"
      invalid_scopes = []
    }
    :
    var.organization_id != null
    ?
    length(local.organization_scopes) > 0
    ?
    {
      message        = "Invalid scopes assigned to Resource Group scoped to Organization level"
      invalid_scopes = local.organization_scopes
    }
    :
    {
      message        = "success"
      invalid_scopes = []
    }
    :
    {
      message        = "success"
      invalid_scopes = []
    }
  )

}
