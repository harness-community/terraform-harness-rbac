# Terraform Modules for Harness Resource Groups
Terraform Module for creating and managing Harness Resource Groups

## Summary
This module handle the creation and managment of Resource Groups by leveraging the Harness Terraform provider

## Providers

```
terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
    time = {
      source = "hashicorp/time"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

```

## Variables

_Note: When the identifier variable is not provided, the module will automatically format the identifier based on the provided resource name_

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| harness_platform_account | [Required]  Enter the Harness Platform Account Number | string |  | X |
| name | [Required]  Name of the resource. | string |  | X |
| type | [Required]  The type of environment. Valid values are nonprod or prod| string | nonprod | |
| identifier | [Optional] Provide a custom identifier.  More than 2 but less than 128 characters and can only include alphanumeric or '_' | string | null | |
| organization_id | [Optional] Provide an organization reference ID. Must exist before execution | string | null | |
| project_id | [Optional] Provide an project reference ID. Must exist before execution | string | null | |
| description | [Optional]  Description of the resource. | string | Harness Resource Group created via Terraform | |
| color | [Optional]  Color of the Environment. | string | _Automatically selected if no value provided_ | |
| resource_group_scopes | [Optional] (List of Maps) The scope levels at which this role can be used. See Schema Below | list(object) | [] |  |
| resource_group_filters | [Optional] (List of Maps) The resource group filters to apply. See Schema Below | list(object) | [] | |
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


## Examples
### Build a single Resource Group with minimal inputs at account level
```
module "resource_groups" {
  source = "git@github.com:harness-community/terraform-harness-delivery.git//resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group"

}
```
### Build a single Resource Group with minimal inputs at project level
```
module "resource_groups" {
  source = "git@github.com:harness-community/terraform-harness-delivery.git//resource_groups"

  harness_platform_account = "my-harness-account-id"
  name                     = "test-resource-group"
  organization_id          = "myorg"
  project_id               = "myproject"

}
```

### Build a single Resource Group with resource propagation
```
module "resource_groups_custom_scope_single" {
  source = "git@github.com:harness-community/terraform-harness-delivery.git//resource_groups"

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
  source = "git@github.com:harness-community/terraform-harness-delivery.git//resource_groups"

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
  source = "git@github.com:harness-community/terraform-harness-delivery.git//resource_groups"

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

  source = "../../resource_groups"

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
