# ( Based on https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#example-usage : )
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.52.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}



resource "azurerm_resource_group" "rg_m_p_f_a_c_a_3" {
  name     = "rg-m-p-f-a-c-a-3"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "l_a_w" {
  name                = "l-a-w"
  location            = azurerm_resource_group.rg_m_p_f_a_c_a_3.location
  resource_group_name = azurerm_resource_group.rg_m_p_f_a_c_a_3.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "c_a_e" {
  name                       = "c-a-e"
  location                   = azurerm_resource_group.rg_m_p_f_a_c_a_3.location
  resource_group_name        = azurerm_resource_group.rg_m_p_f_a_c_a_3.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.l_a_w.id
}

# ( Based on https://medium.com/@vivazmo/azure-container-apps-with-terraform-part-1-ae20649e0dff : )
resource "azurerm_container_app" "c_a" {
  name                         = "c-a"

  container_app_environment_id = azurerm_container_app_environment.c_a_e.id
  resource_group_name          = azurerm_resource_group.rg_m_p_f_a_c_a_3.name
  revision_mode                = "Single"

  registry {
    server               = "docker.io"    
    
    username = var.docker_io_username
    password_secret_name = "docker-io-access-token"
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 5000
    traffic_weight {
      percentage = 100
      # The following is added based on the recommendation at
      # https://github.com/hashicorp/terraform-provider-azurerm/issues/20435#issuecomment-1443418097 .
      latest_revision = true
    }
  }

  template {
    container {
      name   = "template-container-m-p-f-a-c-a-3"
      image  = "${var.docker_io_username}/${var.name_of_container_image}:${var.tag_for_container_image}"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  secret {
    name = "docker-io-access-token"
    value = var.docker_io_access_token
  }
}
