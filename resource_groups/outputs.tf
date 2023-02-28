####################
#
# Harness Resource Group Outputs
#
####################
output "resource_group_details" {
  value = harness_platform_resource_group.rg
  description = "Details for the created Harness Resource Group"
}
