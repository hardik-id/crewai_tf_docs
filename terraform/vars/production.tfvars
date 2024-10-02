#RG
resource_group_name = "inficonnectrg"
#log Analytics
log_analytics_workspace_name = "inficonnectlw"
location                     = "westeurope"

# Virtual Network
vnet_name                 = "inficonnectvnet"
network_address_space     = "192.168.0.0/16"
aks_subnet_address_prefix = "192.168.0.0/24"
aks_subnet_address_name   = "aks"
# AKS
aks_name            = "inficonnectaks"
kubernetes_version  = "1.27.7"
agent_count         = 1
vm_size             = "Standard_DS2_v2"
agents_max_count    = "3"
agents_min_count    = "1"
enable_auto_scaling = "true"
ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxZEk2eRAFjvmGd7rAXtLMWwqacNgMsZIo58QZv9HopGxHt7MmDIwLppqA4efXByUt/nKwpusBdHSeMFgVnyHoLMRjaPql7hL2g4cCXEzpRtnBivd6W2BZXp1hEQ1oWcudQF29+WqluzcLj4UlE1MAZ6M6xW5L8/fXVmJIa6+g00eB7afZne1sevQqOFd7+kV6rsi/+LgZZ8g24Di91DJkILlVkm7YqWMtUkgtuEoyHPhZYxT+vbDUWkVN/13BX2mfMC0IbD7NGc6b1Qp7WR6F0LWKRY+CyO8mQW2wPkgHQ4g/1L/vRTZpfLeM92Vk98r/AXrud1u6zAwQeIq7oT+kgyVDs1bNwlVqJzMPRlAL4zIyiStAx1z1NB6L/5fSkVabhjnj/V2u4RGf5Rvw89B1m4qxI/D/CPTPaIBj8p+ZUsubl8PkI/vz5L5RzBAAHEa0ZooJ5zAytwXCIm9sRAse0pjBPwGut43kz868hXUTNz/p+SqfT1S1o3AXXDZGrwxrIdncuQxY62Q1o+SH8HaQCPkMOZ+jfDt76l+WN0VIRvAXUU2EhfbblgoAbIwhllSowsx7kETC6ChfzXivIRFdeW0wG74ABn7E3Geg+Ywlt8+S7rAnUlWVD6Lgfz/GjFIz0dc1+iKc2uYv/Nrx4POGQfcWjtMl445XCUanvPPy/w== amansharma@DVT-5CG117011F"

# ACR
acr_name = "inficonnectacr"

# App Insights
app_insights_name = "inficonnectai"
application_type  = "web"

# Key vault
keyvault_name    = "inficonnectkv"
access_policy_id = "7da738c2-5c92-401c-87f1-eadbcf714367"

environment = "production"

# PostgreSQL Server #
#####################
postgresql-name           = "inficonnectdatabase"
postgresql-admin-login    = "adminuser"
postgresql-admin-password = "Th1sIsAP@ssw0rd"
postgresql-version        = "11"
postgresql-sku-name       = "B_Gen5_1"
postgresql-storage        = "5120"

#SearchServie

search_name = "inficonnectsearchservice"

#openAI

openai_name                  = "inficonnectopenai"
openai_custom_subdomain_name = "inficonnect-DvtBrainOAI"

openai_deployments = [
  {
    name = "inficonnect-gpt-35-turbo-16k"
    model = {
      name    = "gpt-35-turbo-16k"
      version = "0613"
    }
    rai_policy_name = ""
  },
  {
    name = "inficonnect-gpt4"
    model = {
      name    = "gpt-4"
      version = "0613"
    }
    rai_policy_name = ""
  },
  {
    name = "inficonnect-gpt-4-32k"
    model = {
      name    = "gpt-4-32k"
      version = "0613"
    }
    rai_policy_name = ""
  },
]
