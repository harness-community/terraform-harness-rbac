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
### Build a single Environment with minimal inputs using rendered payload
```
module "environments" {
  source = "git@github.com:harness-community/terraform-harness-delivery.git//environments"

  name             = "test-environment"
  organization_id  = "myorg"
  project_id       = "myproject"
  type             = "nonprod"
}
```

### Build a single Environment with yaml_file overrides using rendered payload
```
module "templates" {
  source = "git@github.com:harness-community/terraform-harness-content.git//templates"

  name             = "test-example"
  organization_id  = "myorg"
  project_id       = "myproject"
  type             = "nonprod"
  yaml_file        = "templates/test-example.yaml"

}
```

### Build a single Environment with raw yaml_data
```
module "templates" {
  source = "git@github.com:harness-community/terraform-harness-content.git//templates"

  name             = "test-example"
  organization_id  = "myorg"
  project_id       = "myproject"
  type             = "nonprod"
  yaml_render      = false
  yaml_data        = <<EOT
  environment:
    name: test-example
    identifier: test_example
    projectIdentifier: myproject
    orgIdentifier: myorg
    description: Harness Environment created via Terraform
    type: PreProduction
    overrides:
      manifests:
      - manifest:
          identifier: manifestEnv
          spec:
            store:
              spec:
                branch: master
                connectorRef: <+input>
                gitFetchType: Branch
                paths:
                - file1
                repoName: <+input>
              type: Git
          type: Values
  EOT

}
```

### Build multiple Environments
```
variable "environment_list" {
    type = list(map())
    default = [
        {
            name        = "cloud1"
            tags        = {
                role    = "nonprod-cloud1"
            }
        },
        {
            name        = "cloud1-prod"
            description = "Production Environment in Cloud1"
            type        = "prod"
            yaml_file   = "templates/environments/cloud1-prod-overrides.yaml"
            tags        = {
                role    = "prod-cloud1"
            }
        },
        {
            name        = "cloud2"
            type        = "nonprod"
            yaml_render = false
            yaml_file   = "templates/environments/cloud2-nonprod-full.yaml"
            tags        = {
                role    = "nonprod-cloud2"
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

module "environments" {
  source = "git@github.com:harness-community/terraform-harness-content.git//environments"
  for_each = { for environment in var.environment_list : environment.name => environment }

  name             = each.value.name
  description      = lookup(each.value, "description", "Harness Environment for ${each.value.name}")
  type             = lookup(each.value, "type", "nonprod")
  yaml_render      = lookup(each.value, "render", true)
  yaml_file        = lookup(each.value, "yaml_file", null)
  yaml_data        = lookup(each.value, "yaml_data", null)
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
