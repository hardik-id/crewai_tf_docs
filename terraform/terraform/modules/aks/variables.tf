

variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
  default = "westeurope"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "kubernetes_version" {
}

variable "agent_count" {
}

variable "vm_size" {
}

variable "dns_prefix" {
  default = "inficonnect"
}

variable "kubernetes_cluster_rbac_enabled" {
  default = "true"
}

variable "aks_admins_group_object_id" {
  default = "e97b6454-3fa1-499e-8e5c-5d631e9ca4d1"
}

variable "addons" {
  description = "Defines which addons will be activated."
  type = object({
    oms_agent                   = bool
    azure_policy                = bool
    ingress_application_gateway = bool
  })
}

variable "log_analytics_workspace_id" {
}

variable "aks_subnet" {
}

variable "environment" {
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