locals {
  organization_id = harness_platform_organization.test.id
  organization_secondary_id = harness_platform_organization.secondary.id
  project_id      = harness_platform_project.test.id
  project_secondary_id = harness_platform_project.secondary.id
  fmt_prefix = (
    lower(
      replace(
        replace(
          var.prefix,
          " ",
          "_"
        ),
        "-",
        "_"
      )
    )
  )

  common_tags = merge(
    var.global_tags,
    {
      purpose = "terraform-testing"
    }
  )
}
