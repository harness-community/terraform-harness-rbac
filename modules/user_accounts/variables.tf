####################
#
# Harness User Account Variables
#
####################
variable "email_address" {
  type        = string
  description = "[Required] Email Address of the new user"

  validation {
    condition = (
      can(regex("[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", var.email_address))
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] Email Address of the new user must be in a valid format
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

variable "user_groups" {
  type        = list(string)
  description = "[Required] (Set of String) The user group of the user."
}

# [Required] Role Bindings of the user. (see below for nested schema)
#   resource_group_id: (String) Resource Group Identifier of the user.
#   role_id: (String) Role Identifier of the user.
#   is_managed: (Boolean) Managed Role of the user.
variable "role_bindings" {
  type        = list(any)
  description = "[Required] Role Bindings of the user."

  validation {
    condition = (
      alltrue([
        for role_binding in var.role_bindings : (
          lookup(role_binding, "resource_group_id", null) != null &&
          lookup(role_binding, "role_id", null) != null &&
          (
            lookup(role_binding, "is_managed", null) != null
            ?
            contains([true, false], role_binding.is_managed)
            :
            true
          )
        )
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] resource_group_id - (String) Resource Group Identifier of the user.
            * [Required] role_id - (String) Role Identifier of the user.
            * [Optional] is_managed - (Boolean) Managed Role of the user.
        EOF
  }
}
