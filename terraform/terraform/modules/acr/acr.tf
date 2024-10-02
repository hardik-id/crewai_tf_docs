# resource "azurerm_resource_group" "acr_resource_group" {
#   name     = "${var.name}-rg"
#   location = var.location

#   tags = {
#     Environment = var.environment
#   }
# }

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    Environment = var.environment
  }
}