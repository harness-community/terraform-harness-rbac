# Terraform Modules for Harness User Groups
Terraform Module for creating and managing Harness User Groups

## Summary
This module handle the creation and managment of User Groups by leveraging the Harness Terraform provider

## Providers

```
terraform {
  required_providers {
    harness = {
      source = "harness/harness"
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
| tags | [Optional] Provide a Map of Tags to associate with the project | map(any) | {} | |
| global_tags | [Optional] Provide a Map of Tags to associate with the project and resources created | map(any) | {} | |


## Examples
### Build a single User Group with no members at account level
```
module "user_groups" {
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/user_groups"

  name             = "test-group"
}
```
### Build a single User Group with email_addresses at organization level
```
module "user_groups" {
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/user_groups"

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
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/user_groups"

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
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/roles"

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
  source = "git@github.com:harness-community/terraform-harness-content.git//user_groups"
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
