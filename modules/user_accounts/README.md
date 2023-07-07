# Terraform Modules for Harness User Accounts
Terraform Module for creating and managing Harness User Accounts

## Summary
This module handle the creation and managment of User Accounts by leveraging the Harness Terraform provider

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
  }
}
```

## Variables

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| email_address | [Required] Email Address of the new user | string |  | X |
| user_groups | [Required] (Set of String) The user group of the user | list | | X |
| role_bindings | [Required] Role Bindings of the user. See schema below | list | | X |
| organization_id | [Optional] Provide an organization reference ID. Must exist before execution | string | null | |
| project_id | [Optional] Provide an project reference ID. Must exist before execution | string | null | |

### Variables - role_bindings

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| resource_group_id | [Required] Resource Group Identifier for the user | string | | X |
| role_id | [Required] Role Identifier for the user | string | | X |
| is_managed | [Optional] Is this a Harness Managed Role? | boolean | true | |

## Outputs
| Name | Description | Value |
| --- | --- | --- |
| details | Details for the created Harness user account | Map containing details of created user account
| user_account_details | [Deprecated] Details for the created Harness user account | Map containing details of created user account

## Examples
### Build a single User Account at account level
```
module "user_accounts" {
  source = "harness-community/rbac/harness//modules/user_accounts"

  email_address = "john.doe@example.com"
  user_groups   = [
    "_account_all_users"
  ]
  role_bindings = [
    {
        resource_group_id = "_all_account_level_resources"
        role_id = "_account_viewer"
    }
  ]
}
```

## Contributing
A complete [Contributors Guide](../CONTRIBUTING.md) can be found in this repository

## Authors
Module is maintained by Harness, Inc

## License

MIT License. See [LICENSE](../LICENSE) for full details.
