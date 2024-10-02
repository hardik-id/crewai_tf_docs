provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "infini-connect-terra-rg"
    storage_account_name = "icterrasa"
    container_name       = "ic-tfstate"
    key                  = "terraform-base.ic-tfstate"
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = "inficonnectaks"
  resource_group_name = "inficonnectrg"
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)

  }
} 