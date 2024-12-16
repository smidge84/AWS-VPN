##################################################################################
# LOCAL VARIABLES
##################################################################################

locals {
  global_tags = merge(
    {
      Name        = "", # This is here to prevent a bug with the provider when a resource sets the Name tag.
      owner       = var.author
      environment = var.environment
    },
    var.common_tags
  )

  naming_prefix = "${var.naming_prefix}-${var.environment}"
}
