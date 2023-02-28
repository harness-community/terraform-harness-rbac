# Terraform Modules Integration Testing
Terraform Module for creating and managing Harness Projects

## Summary
This module handle the creation and managment of projects by leveraging the Harness Terraform provider

## Providers

```
terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = "~> 0.14.0"
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

| Name | Description | Type | Default Value | Mandatory |
| --- | --- | --- | --- | --- |
| prefix | Adds a Prefix to the organization name prevent collisions. | string | | X |
| harness_platform_url | [Optional] Enter the Harness Platform URL.  Defaults to Harness SaaS URL | string | https://app.harness.io/gateway | |
| harness_platform_account | [Required] Enter the Harness Platform Account Number | string | | X |
| harness_platform_key | [Required] Enter the Harness Platform API Key for your account | | X |
| global_tags | [Optional] Provide a Map of Tags to associate with all organizations and resources create | map | {} | |


## Examples

## Contributing
A complete [Contributors Guide](../CONTRIBUTING.md) can be found in this repository

## Authors
Module is maintained by Harness, Inc

## License

MIT License. See [LICENSE](../LICENSE) for full details.
