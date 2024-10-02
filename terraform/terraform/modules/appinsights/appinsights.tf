# data "azurerm_resource_group" "appinsightsrg" {
#   name = "${var.name}-rg"
# }

resource "azurerm_application_insights" "appinsights" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
}