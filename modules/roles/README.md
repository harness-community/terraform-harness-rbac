# Terraform Modules for Harness Roles
Terraform Module for creating and managing Harness Roles

## Summary
This module handle the creation and managment of Roles by leveraging the Harness Terraform provider

## Supported Terraform Versions
_Note: These modules require a minimum of Terraform Version 1.2.0 to support the Input Validations and Precondition Lifecycle hooks leveraged in the code._

_Note: The list of supported Terraform Versions is based on the most recent of each release which has been tested against this module._

    - v1.2.9
    - v1.3.9
    - v1.4.6
    - v1.5.0
    - v1.5.1
    - v1.5.2

_Note: Terraform version 1.4.1 will not work due to an issue with the Random provider_

## Providers
This module requires that the calling template has defined the [Harness Provider - Docs](https://registry.terraform.io/providers/harness/harness/latest/docs) authentication.

### Example setup of the Harness Provider Authentication with environment variables
You can also set up authentication with Harness through environment variables. To do this set the following items in your environment:
- HARNESS_ENDPOINT: Harness Platform URL, defaults to Harness SaaS URL: https://app.harness.io/gateway
- HARNESS_ACCOUNT_ID: Harness Platform Account Number
- HARNESS_PLATFORM_API_KEY: Harness Platform API Key for your account

### Example setup of the Harness Provider
```
# Provider Setup Details
variable "harness_platform_url" {
  type        = string
  description = "[Optional] Enter the Harness Platform URL.  Defaults to Harness SaaS URL"
  default     = null # If Not passed, then the ENV HARNESS_ENDPOINT will be used or the default value of "https://app.harness.io/gateway"
}

variable "harness_platform_account" {
  type        = string
  description = "[Required] Enter the Harness Platform Account Number"
  default     = null # If Not passed, then the ENV HARNESS_ACCOUNT_ID will be used
  sensitive   = true
}

variable "harness_platform_key" {
  type        = string
  description = "[Required] Enter the Harness Platform API Key for your account"
  default     = null # If Not passed, then the ENV HARNESS_PLATFORM_API_KEY will be used
  sensitive   = true
}

provider "harness" {
  endpoint         = var.harness_platform_url
  account_id       = var.harness_platform_account
  platform_api_key = var.harness_platform_key
}

```


### Terraform required providers declaration
```
terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = ">= 0.14"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.1"
    }
  }
}
```

## Variables

_Note: When the identifier variable is not provided, the module will automatically format the identifier based on the provided resource name_

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| name | [Required] Provide a resource name. Must be at least 1 character but but less than 128 characters | string | | X |
| identifier | [Optional] Provide a custom identifier.  Must be at least 1 character but but less than 128 characters and can only include alphanumeric or '_' | string | null | |
| type | [Required]  The type of environment. Valid values are nonprod or prod| string | nonprod | |
| organization_id | [Optional] Provide an organization reference ID. Must exist before execution | string | null | |
| project_id | [Optional] Provide an project reference ID. Must exist before execution | string | null | |
| description | [Optional]  Description of the resource. | string | Harness Resource Group created via Terraform | |
| role_permissions | [Optional] (Set of String) List of the permission identifiers | list | [] | |
| case_sensitive | [Optional] Should identifiers be case sensitive by default? (Note: Setting this value to `true` will retain the case sensitivity of the identifier) | bool | false | |
| tags | [Optional] Provide a Map of Tags to associate with the project | map(any) | {} | |
| global_tags | [Optional] Provide a Map of Tags to associate with the project and resources created | map(any) | {} | |

## Outputs
| Name | Description | Value |
| --- | --- | --- |
| details | Details for the created Harness role | Map containing details of created role
| role_details | [Deprecated] Details for the created Harness role | Map containing details of created role

## Examples
### Build a single Role with minimal inputs at account level
```
module "roles" {
  source = "harness-community/rbac/harness//modules/roles"

  name             = "test-role"
  role_permissions = [ "core_environment_access", "core_connector_access"]
}
```
### Build a single Role with minimal inputs at project level
```
module "roles" {
  source = "harness-community/rbac/harness//modules/roles"

  name             = "test-role"
  organization_id  = "myorg"
  project_id       = "myproject"
  role_permissions = [ "core_environment_access", "core_connector_access"]
}
```
### Build multiple Roles
```
variable "role_list" {
    type = list(map())
    default = [
        {
            name        = "user_manager"
            role_permissions = ["core_user_view","core_user_invite","core_user_manage"]
        },
        {
            name        = "project_manager"
            description = "Harness Role to Manage Projects in Organization"
            organization_id = "myorg"
            role_permissions = ["core_project_delete","core_project_view","core_project_edit"]
            tags        = {
                role    = "project-admin"
            }
        },
        {
            name        = "pipeline_manager"
            organization_id = "myorg"
            project_id = "myproject"
            role_permissions = ["core_pipeline_execute","core_pipeline_view","core_pipeline_delete","core_pipeline_edit"]
            tags        = {
                role    = "pipeline-admins"
            }
        }
    ]
}

variable "global_tags" {
    type = map()
    default = {
        environment = "NonProd"
    }
}

module "roles" {
  source = "harness-community/rbac/harness//module/roles"
  for_each = { for role in var.role_list : role.name => role }

  name             = each.value.name
  description      = lookup(each.value, "description", "Harness Environment for ${each.value.name}")
  organization_id  = lookup(each.value, "organization_id", null)
  project_id       = lookup(each.value, "project_id", null)
  role_permissions = lookup(each.value, "role_permissions", [])
  tags             = lookup(each.value, "tags", {})
  global_tags      = var.global_tags
}
```

## Contributing
A complete [Contributors Guide](../CONTRIBUTING.md) can be found in this repository

## Authors
Module is maintained by Harness, Inc

## License

MIT License. See [LICENSE](../LICENSE) for full details.
