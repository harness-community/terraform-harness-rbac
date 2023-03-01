####################
#
# Harness Role Outputs
#
####################
output "role_details" {
  value       = harness_platform_roles.role
  description = "Details for the created Harness Role"
}
