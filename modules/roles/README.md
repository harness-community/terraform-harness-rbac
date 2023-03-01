# Terraform Modules for Harness Roles
Terraform Module for creating and managing Harness Roles

## Summary
This module handle the creation and managment of Roles by leveraging the Harness Terraform provider

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
  }
}

```

## Variables

_Note: When the identifier variable is not provided, the module will automatically format the identifier based on the provided resource name_

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| name | [Required]  Name of the resource. | string |  | X |
| type | [Required]  The type of environment. Valid values are nonprod or prod| string | nonprod | |
| identifier | [Optional] Provide a custom identifier.  More than 2 but less than 128 characters and can only include alphanumeric or '_' | string | null | |
| organization_id | [Optional] Provide an organization reference ID. Must exist before execution | string | null | |
| project_id | [Optional] Provide an project reference ID. Must exist before execution | string | null | |
| description | [Optional]  Description of the resource. | string | Harness Resource Group created via Terraform | |
| role_permissions | [Optional] (Set of String) List of the permission identifiers | list | [] | |
| tags | [Optional] Provide a Map of Tags to associate with the project | map(any) | {} | |
| global_tags | [Optional] Provide a Map of Tags to associate with the project and resources created | map(any) | {} | |


## Examples
### Build a single Role with minimal inputs at account level
```
module "roles" {
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/roles"

  name             = "test-role"
  role_permissions = [ "core_environment_access", "core_connector_access"]
}
```
### Build a single Role with minimal inputs at project level
```
module "roles" {
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/roles"

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
  source = "git@github.com:harness-community/terraform-harness-content.git//roles"
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
