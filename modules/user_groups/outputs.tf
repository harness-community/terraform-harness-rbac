####################
#
# Harness User Group Outputs
#
####################
output "user_group_details" {
  value       = harness_platform_usergroup.group
  description = "Details for the created Harness User Group"
}
