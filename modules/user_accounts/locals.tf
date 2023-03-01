####################
#
# Harness User Account Local Variables
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

  fmt_identifier = (
    var.identifier == null
    ?
    (
      lower(
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
    )
    :
    var.identifier
  )

  # Set the allowed scope levels based on the provided
  # details for where the resource group will be created.
  allowed_scope_levels = (
    var.project_id != null
    ?
    "project"
    :
    var.organization_id != null
    ?
    "organization"
    :
    "account"
  )

  # binding_validation = (
  #   var.resource_group_id != null && var.role_id != null
  #   ?
  #     true
  #   :
  #     var.resource_group_id != null || var.role_id != null
  #     ?
  #       false
  #     :
  #       true
  # )

}
