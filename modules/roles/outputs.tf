####################
#
# Harness Role Outputs
#
####################
# 2023-03-16
# This output is being deprecated and replaced by the output
# labeled `details`
# output "role_details" {
#   value       = harness_platform_roles.role
#   description = "Details for the created Harness Role"
# }

output "details" {
  value       = harness_platform_roles.role
  description = "Details for the created Harness Role"
}
