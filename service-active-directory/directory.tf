resource "aws_directory_service_directory" "directory" {
  name       = local.domain_name
  short_name = local.common_name

  description = "Microsoft AD for ${local.common_name}.local"
  password    = local.admin_password

  enable_sso = false
  type       = var.active_directory_configs["type"]
  edition    = var.active_directory_configs["edition"]


  vpc_settings {
    vpc_id     = local.vpc_id
    subnet_ids = local.subnet_ids
  }

  tags = merge(
    local.tags,
    {
      "Name" = local.common_name
    },
  )

  # Required as AWS does not allow you to change the Admin password post AD Create - you must destroy/recreate 
  # When we run tf plan against an already created AD it will always show the AD needs destroy/create so we ignore
  lifecycle {
    ignore_changes = [
      password
    ]
  }

}
