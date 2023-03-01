####################
#
# Harness User Accounts Validations
#
####################
locals {
  user_account_outputs = flatten([
    {
      test = true
      # minimum             = module.user_accounts_minimal.user_account_details
    }
  ])
}

# 2023-03-01
# Disabled due to provider bug in how users are created and managed
#
# module "user_accounts_minimal" {

#   source = "../../modules/user_accounts"

#   name            = "test-user-account-minimal"
#   email_address   = "jeremy.goodrum+test@harness.io"
#   organization_id = local.organization_id
#   project_id      = local.project_id
#   user_groups     = ["_project_all_users"]
#   role_bindings = [{
#     role_id              = "_project_admin"
#     resource_group_id    = "_all_project_level_resources"
#   }]
#   global_tags     = local.common_tags

# }
