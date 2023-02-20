# Create a resource group for all our resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create an Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "${var.app_name}ACR"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  admin_enabled       = true
}

# Build and push docker image to ACR
resource "null_resource" "build_and_publish_image" {
  depends_on = [azurerm_container_registry.acr]

  provisioner "local-exec" {
    command = "bash build-and-publish-image.sh ${azurerm_container_registry.acr.login_server} ${azurerm_container_registry.acr.admin_username} ${azurerm_container_registry.acr.admin_password}"
  }
}

# Create an Azure Container Instance with the Docker image
resource "azurerm_container_group" "ac" {
  name                = var.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = "Always"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = var.app_name
    image  = "${azurerm_container_registry.acr.login_server}/challenge-app:latest"
    cpu    = "2"
    memory = "4"

    # Configure the FastAPI application to listen on port 80
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  depends_on = [null_resource.build_and_publish_image]

}

# Output public IP of the deployed FastAPI application
output "app_ip" {
  value = "http://${azurerm_container_group.ac.ip_address}/docs"
}
