# Terraform Modules for Harness User Groups
Terraform Module for creating and managing Harness User Groups

## Summary
This module handle the creation and managment of User Groups by leveraging the Harness Terraform provider

## Supported Terraform Versions
_Note: These modules require a minimum of Terraform Version 1.2.0 to support the Input Validations and Precondition Lifecycle hooks leveraged in the code._

_Note: The list of supported Terraform Versions is based on the most recent of each release which has been tested against this module._

    - v1.2.9
    - v1.3.9
    - v1.4.0
    - v1.4.2
    - v1.4.3
    - v1.4.4
    - v1.4.5
    - v1.4.6

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
  }
}
```

## Variables

_Note: When the identifier variable is not provided, the module will automatically format the identifier based on the provided resource name_

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| name | [Required]  Name of the resource. | string |  | X |
| identifier | [Optional] Provide a custom identifier.  More than 2 but less than 128 characters and can only include alphanumeric or '_' | string | null | |
| organization_id | [Optional] Provide an organization reference ID. Must exist before execution | string | null | |
| project_id | [Optional] Provide an project reference ID. Must exist before execution | string | null | |
| description | [Optional]  Description of the resource. | string | Harness Resource Group created via Terraform | |
| user_email_addresses | [Optional] (Set of String) List of user emails in the UserGroup. Either provide list of users or list of user emails | list | [] | |
| user_names | [Optional] (Set of String) List of users in the UserGroup. Either provide list of users or list of user emails | list | [] | |
| role_id | [Optional] Role to associate with the User Group. | string | null | |
| resource_group_id | [Optional] Resource Group to associate with the User Group. | string | null | |
| is_enabled | [Optional] Should the role binding be enabled? | bool | true | |
| is_managed | [Optional] Should the role binding be managed? | bool | false | |
| has_binding | [Optional] Should the role binding be created? | bool | false | |
| tags | [Optional] Provide a Map of Tags to associate with the project | map(any) | {} | |
| global_tags | [Optional] Provide a Map of Tags to associate with the project and resources created | map(any) | {} | |

## Outputs
| Name | Description | Value |
| --- | --- | --- |
| details | Details for the created Harness user group | Map containing details of created user group
| user_group_details | [Deprecated] Details for the created Harness user group | Map containing details of created user group

## Examples
### Build a single User Group with no members at account level
```
module "user_groups" {
  source = "harness-community/rbac/harness//modules/user_groups"

  name             = "test-group"
}
```
### Build a single User Group with email_addresses at organization level
```
module "user_groups" {
  source = "harness-community/rbac/harness//modules/user_groups"

  name             = "test-group"
  organization_id  = "myorg"
  user_email_addresses = [
    "alpha@testdomain.com",
    "bravo@testdomain.com",
    "charlie@testdomain.com"
  ]
}
```
### Build a single User Group with user_names at organization level
```
module "user_groups" {
  source = "harness-community/rbac/harness//modules/user_groups"

  name             = "test-group"
  organization_id  = "myorg"
  user_names = [
    "alpha",
    "bravo",
    "charlie"
  ]
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
### Build multiple User Groups
```
variable "user_group_list" {
    type = list(map())
    default = [
        {
            name        = "account_admins"
            user_email_addresses = [
                "alpha@testdomain.com",
                "bravo@testdomain.com",
                "charlie@testdomain.com"
            ]
        },
        {
            name            = "org_admins"
            organization_id = "myorg"
            user_email_addresses = [
                "delta@testdomain.com",
                "echo@testdomain.com",
                "foxtrot@testdomain.com"
            ]
        },
        {
            name            = "project_developers"
            organization_id = "myorg"
            project_id      = "myproject"
            user_names = [
                "homer",
                "marge",
                "bart",
                "lisa",
                "maggie"
            ]
        },
    ]
}

variable "global_tags" {
    type = map()
    default = {
        environment = "NonProd"
    }
}

module "user_groups" {
  source = "harness-community/rbac/harness//modules/user_groups"
  for_each = { for user_group in var.user_group_list : user_group.name => user_group }

  name             = each.value.name
  description      = lookup(each.value, "description", "Harness Environment for ${each.value.name}")
  organization_id  = lookup(each.value, "organization_id", null)
  project_id       = lookup(each.value, "project_id", null)
  user_email_addresses = lookup(each.value, "user_email_addresses", [])
  user_names           = lookup(each.value, "user_names", [])
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
