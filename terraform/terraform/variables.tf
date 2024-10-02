variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics Workspace Name"
}

variable "location" {
  type        = string
  description = "Location of Resources"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
}

variable "network_address_space" {
  type        = string
  description = "Virtual Network Address Space"
}

variable "aks_subnet_address_prefix" {
  type        = string
  description = "AKS Subnet Address Prefix"
}

variable "aks_subnet_address_name" {
  type        = string
  description = "AKS Subnet Name"
}

variable "aks_name" {
  type        = string
  description = "AKS Name"
}

variable "kubernetes_version" {
  type        = string
  description = "AKS K8s Version"
}

variable "agent_count" {
  type        = string
  description = "AKS Agent Count"
}

variable "vm_size" {
  type        = string
  description = "AKS VM Size"
}

variable "acr_name" {
  type        = string
  description = "ACR Name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH key for AKS Cluster"
}

variable "app_insights_name" {
  type        = string
  description = "Application Insights Name"
}

variable "application_type" {
  type        = string
  description = "Application Insights Type"
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault Name"
}

variable "access_policy_id" {
  type        = string
  description = "Object ID for Key Vault Policy"
}
variable "postgresql-name" {
  type        = string
  description = " PostgreSQL Server Name "
}
variable "postgresql-admin-login" {
  type        = string
  description = "Login to authenticate to PostgreSQL Server"
}

variable "postgresql-admin-password" {
  type        = string
  description = "Password to authenticate to PostgreSQL Server"
}

variable "postgresql-version" {
  type        = string
  description = "PostgreSQL Server version to deploy"
  default     = "11"
}

variable "postgresql-sku-name" {
  type        = string
  description = "PostgreSQL SKU Name"
  default     = "B_Gen5_1"
}

variable "postgresql-storage" {
  type        = string
  description = "PostgreSQL Storage in MB, from 5120 MB to 4194304 MB"
  default     = "5120"
}

variable "openai_name" {
  description = "(Required) Specifies the name of the Azure OpenAI Service"
  type        = string
  default     = "inficonnect-OpenAi"
}

variable "openai_sku_name" {
  description = "(Optional) Specifies the sku name for the Azure OpenAI Service"
  type        = string
  default     = "S0"
}

variable "openai_custom_subdomain_name" {
  description = "(Optional) Specifies the custom subdomain name of the Azure OpenAI Service"
  type        = string
  nullable    = true
  default     = "inficonnect-DvtBrainOAI"
}

variable "openai_public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed for the Azure OpenAI Service"
  type        = bool
  default     = true
}

variable "openai_deployments" {
  description = "(Optional) Specifies the deployments of the Azure OpenAI Service"
  type = list(object({
    name = string
    model = object({
      name    = string
      version = string
    })
    rai_policy_name = string
  }))
  default = [
    {
      name = "gpt-35-turbo"
      model = {
        name    = "gpt-35-turbo"
        version = "0301"
      }
      rai_policy_name = ""
    }
  ]
}

variable "search_name" {
  description = "Service name must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and is limited between 2 and 60 characters in length."
}

variable "sku" {
  description = "Valid values are 'free', 'standard', 'standard2', and 'standard3' (2 & 3 must be enabled on the backend by Microsoft support). 'free' provisions the service in shared clusters. 'standard' provisions the service in dedicated clusters."
  default     = "free"
}

variable "replica_count" {
  description = "Replicas distribute search workloads across the service. You need 2 or more to support high availability (applies to Basic and Standard only)."
  default     = 1
}

variable "partition_count" {
  description = "Partitions allow for scaling of document count as well as faster indexing by sharding your index over multiple Azure Search units. Allowed values: 1, 2, 3, 4, 6, 12"
  default     = 1
}

variable "hosting_mode" {
  description = "Applicable only for SKU set to standard3. You can set this property to enable a single, high density partition that allows up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. Allowed values: default, highDensity"
  default     = "default"
}

variable "agents_max_count" {
  type        = number
  default     = null
  description = "Maximum number of nodes in a pool"
}
variable "agents_min_count" {
  type        = number
  default     = null
  description = "Minimum number of nodes in a pool"
}
variable "enable_auto_scaling" {
  type        = bool
  default     = false
  description = "Enable node pool autoscaling"
}