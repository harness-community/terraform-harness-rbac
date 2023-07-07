# Terraform Modules for Harness Resource Groups
Terraform Module for creating and managing Harness Resource Groups

## Summary
This module handle the creation and managment of Resource Groups by leveraging the Harness Terraform provider

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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
}
```

## Variables

_Note: When the identifier variable is not provided, the module will automatically format the identifier based on the provided resource name_

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| harness_platform_account | [Required]  Enter the Harness Platform Account Number | string |  | X |
| name | [Required] Provide a resource name. Must be at least 1 character but but less than 128 characters | string | | X |
| identifier | [Optional] Provide a custom identifier.  Must be at least 1 character but but less than 128 characters and can only include alphanumeric or '_' | string | null | |
| identifier | [Optional] Provide a custom identifier.  More than 2 but less than 128 characters and can only include alphanumeric or '_' | string | null | |
| organization_id | [Optional] Provide an organization reference ID. Must exist before execution | string | null | |
| project_id | [Optional] Provide an project reference ID. Must exist before execution | string | null | |
| description | [Optional]  Description of the resource. | string | Harness Resource Group created via Terraform | |
| color | [Optional]  Color of the Environment. | string | _Automatically selected if no value provided_ | |
| resource_group_scopes | [Optional] (List of Maps) The scope levels at which this role can be used. See Schema Below | list(object) | [] |  |
| resource_group_filters | [Optional] (List of Maps) The resource group filters to apply. See Schema Below | list(object) | [] | |
| case_sensitive | [Optional] Should identifiers be case sensitive by default? (Note: Setting this value to `true` will retain the case sensitivity of the identifier) | bool | false | |
| tags | [Optional] Provide a Map of Tags to associate with the project | map(any) | {} | |
| global_tags | [Optional] Provide a Map of Tags to associate with the project and resources created | map(any) | {} | |

### Variables - resource_group_scopes
| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| filter | [Optional] Can be one of these 2 EXCLUDING_CHILD_SCOPES or INCLUDING_CHILD_SCOPES | string | INCLUDING_CHILD_SCOPES | |
| organization_id | [Optional] Organization Identifier. Required if Resource Group created at Organization or Project level. | string | | |
| project_id | [Optional] Project Identifier. Required if Resource Group created at Project level. | string | | |

### Variables - resource_group_filters
| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| type | [Optional] Type of Resource | string | | X |
| identifiers | (Set of String) List of the identifiers | list | [] | |
| filters | [Optional] Used to filter resources on their attributes | list(object) | [] | |

### Variables - resource_group_filters.filters
| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| name | [Required] Name of the attribute | string | | X |
| values | [Required] Value of the attributes | list | | X |

## Outputs
| Name | Description | Value |
| --- | --- | --- |
| details | Details for the created Harness resource group | Map containing details of created resource group
| resource_group_details | [Deprecated] Details for the created Harness resource group | Map containing details of created resource group

## Examples
### Build a single Resource Group with minimal inputs at account level
```
module "resource_groups" {
  source = "harness-community/rbac/harness//modules/resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group"

}
```
### Build a single Resource Group with minimal inputs at project level
```
module "resource_groups" {
  source = "harness-community/rbac/harness//modules/resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group"
  organization_id          = "myorg"
  project_id               = "myproject"

}
```

### Build a single Resource Group with resource propagation
```
module "resource_groups_custom_scope_single" {
  source = "harness-community/rbac/harness//modules/resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group"
  resource_group_scopes = [{
    filter = "INCLUDING_CHILD_SCOPES"
  }]
  global_tags = local.common_tags

}
```

### Build a single Resource Group without resource propagation
```
module "resource_groups_custom_scope_single" {
  source = "harness-community/rbac/harness//modules/resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group"
  resource_group_scopes = [{
    filter = "EXCLUDING_CHILD_SCOPES"
  }]
  global_tags = local.common_tags

}
```

### Build a single Resource Group with a custom scope to a Project
```
module "resource_groups_custom_scope" {
  source = "harness-community/rbac/harness//modules/resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group-custom-scope"
  organization_id          = "myorg"
  project_id               = "myproject"
  resource_group_scopes = [
    {
      filter = "EXCLUDING_CHILD_SCOPES"
      organization_id          = "myorg"
      project_id               = "myproject"
    }
  ]
  global_tags = local.common_tags

}
```

### Build a single Resource Group with multiple resource filters
```module "resource_groups_resource_filter_with_filters" {

  source = "harness-community/rbac/harness//modules/resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group-with-filters"
  organization_id          = "myorg"
  project_id               = "myproject"
  global_tags              = local.common_tags
  resource_group_filters = [
    {
        type = "ENVIRONMENT"
        filters = [
            {
                name = "type"
                values = [
                  "PreProduction"
                ]
            }
        ]
    },
    {
        type = "CONNECTOR"
        filters = [
            {
                name = "category"
                values = "CLOUD_PROVIDER, SECRET_MANAGER"
            }
        ]
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
