####################
#
# Harness Structure Default Module Outputs
#
####################
output "organization" {
  value = data.harness_platform_organization.org
  description = "Details for a Harness Platform Organization"
}

output "project" {
  value = data.harness_platform_project.project
  description = "Details for a Harness Platform Project"
}
