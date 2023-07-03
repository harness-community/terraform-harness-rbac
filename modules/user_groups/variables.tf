####################
#
# Harness User Group Variables
#
####################
variable "identifier" {
  type        = string
  description = "[Optional] Provide a custom identifier.  Must be at least 1 character but less than 128 characters and can only include alphanumeric or '_'"
  default     = null

  validation {
    condition = (
      var.identifier != null
      ?
      can(regex("^[0-9A-Za-z][0-9A-Za-z_]{0,127}$", var.identifier))
      :
      true
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide a custom identifier.  Must be at least 1 character but less than 128 characters and can only include alphanumeric or '_'.
            Note: If not set, Terraform will auto-assign an identifier based on the name of the resource
        EOF
  }
}
variable "name" {
  type        = string
  description = "[Required] Provide a resource name. Must be at least 1 character but but less than 128 characters"

  validation {
    condition = (
      length(var.name) > 1
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] Provide a resource name. Must be at least 1 character but but less than 128 characters.
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

variable "user_email_addresses" {
  type        = list(string)
  description = "[Optional] List of user emails in the UserGroup. Either provide list of users or list of user emails"
  default     = []

  validation {
    condition = (
      alltrue([
        for email in var.user_email_addresses : (
          can(regex("[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", email))
        )
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
      * [Optional] List of user emails in the UserGroup.
        Note: All Email addresses need to be valid and at least one or more failed validation
        EOF
  }
}

variable "user_names" {
  type        = list(string)
  description = "[Optional] List of users in the UserGroup. Either provide list of users or list of user emails."
  default     = []
}

variable "resource_group_id" {
  type        = string
  description = "[Optional] Resource group identifier."
  default     = null
}

variable "role_id" {
  type        = string
  description = "[Optional] Role identifier."
  default     = null
}

variable "is_enabled" {
  type        = bool
  description = "[Optional] Should the role binding be enabled?"
  default     = true
}

variable "is_managed" {
  type        = bool
  description = "[Optional] Should the role binding be managed?"
  default     = false
}

variable "has_binding" {
  type        = bool
  description = "[Optional] Should the role binding be created?"
  default     = false
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
