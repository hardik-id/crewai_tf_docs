resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "loganalytics" {
  source                       = "./modules/log-analytics"
  resource_group_name          = azurerm_resource_group.rg.name
  log_analytics_workspace_name = var.log_analytics_workspace_name
  location                     = var.location
  log_analytics_workspace_sku  = "PerGB2018"
  environment                  = var.environment
}

module "vnet_aks" {
  source                    = "./modules/vnet"
  resource_group_name       = azurerm_resource_group.rg.name
  name                      = var.vnet_name
  location                  = var.location
  network_address_space     = var.network_address_space
  aks_subnet_address_prefix = var.aks_subnet_address_prefix
  aks_subnet_address_name   = var.aks_subnet_address_name
  environment               = var.environment
}

module "aks" {
  source                     = "./modules/aks"
  resource_group_name        = azurerm_resource_group.rg.name
  name                       = var.aks_name
  kubernetes_version         = var.kubernetes_version
  enable_auto_scaling        = var.enable_auto_scaling
  agents_max_count           = var.agents_max_count
  agents_min_count           = var.agents_min_count
  agent_count                = var.agent_count
  vm_size                    = var.vm_size
  location                   = var.location
  ssh_public_key             = var.ssh_public_key
  log_analytics_workspace_id = module.loganalytics.id
  aks_subnet                 = module.vnet_aks.aks_subnet_id
  environment                = var.environment


  addons = {
    oms_agent                   = true
    azure_policy                = false
    ingress_application_gateway = true
  }

}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  acr_name            = var.acr_name
  location            = var.location
  environment         = var.environment
}

# resource "azurerm_role_assignment" "aks-vnetid" {
#   scope                = module.vnet_aks.vnet_id
#   role_definition_name = "Network Contributor"
#   principal_id         = module.aks.kubelet_object_id

#      depends_on = [
#      module.aks
#   ]
# }

resource "azurerm_role_assignment" "aks-acr-rg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Acrpull"
  principal_id         = module.aks.kubelet_object_id

  depends_on = [
    module.aks,
    module.acr
  ]
}

module "appinsights" {
  source              = "./modules/appinsights"
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.app_insights_name
  location            = var.location
  environment         = var.environment
  application_type    = var.application_type
}

module "keyvault" {
  source              = "./modules/keyvault"
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.keyvault_name
  access_policy_id    = var.access_policy_id
}

# data "azurerm_resource_group" "mi_rg" {
#   name = "mi-rg"
# }

# resource "azurerm_role_assignment" "aks-mi-rg" {
#   scope                = data.azurerm_resource_group.mi_rg.id
#   role_definition_name = "Contributor"
#   principal_id         = module.aks.kubelet_object_id

#        depends_on = [
#      module.aks
#   ]
# }

module "sql" {
  source                    = "./modules/sql"
  name                      = var.postgresql-name
  resource_group_name       = azurerm_resource_group.rg.name
  postgresql-admin-login    = var.postgresql-admin-login
  postgresql-admin-password = var.postgresql-admin-password
  location                  = var.location
}

module "openai" {
  source                        = "./modules/openai"
  openai_name                   = var.openai_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku_name                      = var.openai_sku_name
  deployments                   = var.openai_deployments
  custom_subdomain_name         = var.openai_custom_subdomain_name
  public_network_access_enabled = var.openai_public_network_access_enabled
  log_analytics_workspace_id    = module.loganalytics.id
}

module "searchservice" {
  source              = "./modules/searchservice"
  search_name         = var.search_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.sku
  replica_count       = var.replica_count
  partition_count     = var.partition_count
}
