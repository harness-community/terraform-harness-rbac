####################
#
# Harness User Group Outputs
#
####################
# 2023-03-16
# This output is being deprecated and replaced by the output
# labeled `details`
# output "user_group_details" {
#   value       = harness_platform_usergroup.group
#   description = "Details for the created Harness User Group"
# }

output "details" {
  value       = harness_platform_usergroup.group
  description = "Details for the created Harness User Group"
}
