locals {
  #storage_account_name_app_01               = var.deploy_resource ? module.storage_account_app_01[0].name : null
  #storage_account_primary_access_key_app_01 = var.deploy_resource ? module.storage_account_app_01[0].primary_access_key : null

  # Dev Integration DNS Zones Info
  resource_group_name_admin_dev = "USEDCXS05HRSG02"

  # TAGS
  ## Base tags per main environment
  environment_base_tags = {
    DEV = {
      DEPLOYMENT_ID = "CXS05H"
      ENGAGEMENT_ID = "I-69197406"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "Development"
    }
    QA = {
      DEPLOYMENT_ID = "CXS05H"
      ENGAGEMENT_ID = "I-68403024"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "QA"
    }
    UAT = {
      DEPLOYMENT_ID = "EYXU01"
      ENGAGEMENT_ID = "I-69197406"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "UAT"
    }
    PROD = {
      DEPLOYMENT_ID = "EYPU01"
      ENGAGEMENT_ID = "I-69197406"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "PROD"
    }
  }

  general_tags = local.environment_base_tags[var.env]

}

