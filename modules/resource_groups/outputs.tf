####################
#
# Harness Resource Group Outputs
#
####################
# 2023-03-16
# This output is being deprecated and replaced by the output
# labeled `details`
output "resource_group_details" {
  value       = harness_platform_resource_group.rg
  description = "Details for the created Harness Resource Group"
}

output "details" {
  value       = harness_platform_resource_group.rg
  description = "Details for the created Harness Resource Group"
}
