# ( Based on https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#example-usage :)
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



resource "azurerm_resource_group" "example" {
  name     = "rg-m-p-f-a-c-a-3"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "example" {
  name                       = "Example-Environment"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

# resource "azurerm_container_app" "example" {
#   name                         = "example-app"
#   container_app_environment_id = azurerm_container_app_environment.example.id
#   resource_group_name          = azurerm_resource_group.example.name
#   revision_mode                = "Single"

#   template {
#     container {
#       name   = "examplecontainerapp"
#       # image  = "https://hub.docker.com/repository/docker/kaloyanmarinov/msdocs-python-flask-azure-container-apps-3:d19787ba9ce395e9f87fefe6ab6423ea904358a1"
#       image  = "hub.docker.com/repository/docker/kaloyanmarinov/msdocs-python-flask-azure-container-apps-3:d19787ba9ce395e9f87fefe6ab6423ea904358a1"
#       cpu    = 0.25
#       memory = "0.5Gi"
#     }
#   }
# }
# ( Based on https://medium.com/@vivazmo/azure-container-apps-with-terraform-part-1-ae20649e0dff :)
resource "azurerm_container_app" "example" {
  name                         = "example-app"

  container_app_environment_id = azurerm_container_app_environment.example.id
  resource_group_name          = azurerm_resource_group.example.name
  revision_mode                = "Single"

  registry {
    server               = "docker.io"    
    
    username = "kaloyanmarinov"
    password_secret_name = "docker-io-pass"
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    # target_port                = 80
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
      name   = "examplecontainerapp"
      image  = "kaloyanmarinov/msdocs-python-flask-azure-container-apps-3:49533f59d4c149f9610b9501df299a4ab29ea1fa"
      cpu    = 0.25
      memory = "0.5Gi"
      # cpu    = 0.5
      # memory = "1Gi"

      # cpu    = "0.5"
      # memory = "1.0Gi"

      # resources {
      #   requests {
      #     cpu    = "0.25"
      #     memory = "0.5Gi"
      #   }
      #   limits {
      #     cpu    = "0.5"
      #     memory = "1.0Gi"
      #   }
      # }
    }

    # tags = local.default_tags
  }

  secret {
    name = "docker-io-pass"
    value = var.docker_io_pass
  }
}