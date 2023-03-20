# Terraform Modules for Harness User Accounts
Terraform Module for creating and managing Harness User Accounts

## Summary
This module handle the creation and managment of User Accounts by leveraging the Harness Terraform provider

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
  source = "git@github.com:harness-community/terraform-harness-rbac.git//modules/user_accounts"

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
