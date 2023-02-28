####################
#
# Harness Resource Group Variables
#
####################
variable "harness_platform_account" {
  type        = string
  description = "[Required] Enter the Harness Platform Account Number"
}
variable "identifier" {
  type        = string
  description = "[Optional] Provide a custom identifier.  More than 2 but less than 128 characters and can only include alphanumeric or '_'"
  default     = null

  validation {
    condition = (
      var.identifier != null
      ?
      can(regex("^[0-9A-Za-z][0-9A-Za-z_]{2,127}$", var.identifier))
      :
      true
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide a custom identifier.  More than 2 but less than 128 characters and can only include alphanumeric or '_'.
            Note: If not set, Terraform will auto-assign an identifier based on the name of the resource
        EOF
  }
}
variable "name" {
  type        = string
  description = "[Required] (String) Name of the resource."

  validation {
    condition = (
      length(var.name) > 2
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] Provide a project name.  Must be two or more characters.
        EOF
  }
}
variable "organization_id" {
  type        = string
  description = "[Optional] Provide an organization reference ID.  Must exist before execution"
  default     = null

  validation {
    condition = (
      var.organization_id != null
      ?
      length(var.organization_id) > 2
      :
      true
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide an organization name.  Must exist before execution.
        EOF
  }
}

variable "project_id" {
  type        = string
  description = "[Optional] Provide an project reference ID.  Must exist before execution"
  default     = null

  validation {
    condition = (
      var.project_id != null
      ?
      can(regex("^([a-zA-Z0-9_]*)", var.project_id))
      :
      true
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide an project name.  Must exist before execution.
        EOF
  }
}

variable "color" {
  type        = string
  description = "[Optional] (String) Color of the Environment."
  default     = null

  validation {
    condition = (
      anytrue([
        can(regex("^#([A-Fa-f0-9]{6})", var.color)),
        var.color == null
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide Pipeline Color Identifier.  Must be a valid Hex Color code.
        EOF
  }
}

variable "description" {
  type        = string
  description = "[Optional] (String) Description of the resource."
  default     = "Harness Resource Group created via Terraform"

  validation {
    condition = (
      length(var.description) > 6
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide an Pipeline description.  Must be six or more characters.
        EOF
  }
}

variable "resource_group_scopes" {
  type        = list(any)
  description = "[Optional] (List of Maps) The scope levels at which this role can be used"
  default     = []

  validation {
    condition = (
      alltrue([
        for scope in var.resource_group_scopes : (
          contains(["EXCLUDING_CHILD_SCOPES", "INCLUDING_CHILD_SCOPES"], lookup(scope, "filter", "INCLUDING_CHILD_SCOPES")) &&
          (lookup(scope, "organization_id", null) != null ? length(scope.organization_id)>2 : true ) &&
          (lookup(scope, "project_id", null) != null ? length(scope.project_id)>2 : true )
        )
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
        [Optional] (List of Maps) The scope levels at which this role can be used
            * [Optional] (String) filter - (String) Can be one of these 2 EXCLUDING_CHILD_SCOPES or INCLUDING_CHILD_SCOPES
            * [Optional] (String) organization_id - (String) Organization Identifier
            * [Optional] (String) project_id - (String) Project Identifier
        EOF
  }
}

variable "resource_group_filters" {
  type        = any
  description = "[Optional] (List of Maps) The resource group filters to apply"
  default     = []

  validation {
    condition = (
      alltrue([
        for filter in var.resource_group_filters : (
          (lookup(filter, "type", null) != null ? length(filter.type)>2 : false ) &&
          (
            lookup(filter, "identifiers", null) != null
            ?
              can(filter.identifiers[0])
            :
              true
          ) &&
          (
            lookup(filter, "filters", null) != null
            ?
              length(flatten([
                for filter in filter.filters : [
                  true
                ] if lookup(filter, "name", null) != null &&
                  lookup(filter, "values", null) != null
              ])) > 0
            :
              true
          )
        )
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
        [Optional] (List of Maps) The scope levels at which this role can be used
            * [Required] (String) type - (String) Must be a valid Harness Resource Type
            * [Optional] (String) identifiers - (Set of String) List of the identifiers
            * [Optional] (String) filters - (Set of Maps) Filter Definitions
              * [Required] (String) name - (String) Name of the attribute
              * [Required] (String) values - (Set of String) Value of the attributes
        EOF
  }
}

variable "tags" {
  type        = map(any)
  description = "[Optional] Provide a Map of Tags to associate with the environment"
  default     = {}

  validation {
    condition = (
      length(keys(var.tags)) == length(values(var.tags))
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide a Map of Tags to associate with the project
        EOF
  }
}

variable "global_tags" {
  type        = map(any)
  description = "[Optional] Provide a Map of Tags to associate with the project and resources created"
  default     = {}

  validation {
    condition = (
      length(keys(var.global_tags)) == length(values(var.global_tags))
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide a Map of Tags to associate with the project and resources created
        EOF
  }
}
