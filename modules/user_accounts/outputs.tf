####################
#
# Harness User Account Outputs
#
####################
# 2023-03-16
# This output is being deprecated and replaced by the output
# labeled `details`
output "user_account_details" {
  value       = harness_platform_user.user
  description = "Details for the created Harness User Account"
}

output "details" {
  value       = harness_platform_user.user
  description = "Details for the created Harness User Account"
}
