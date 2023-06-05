# Define variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "servicebus_namespace_name" {
  description = "Name of the Service Bus namespace"
  type        = string
}

variable "topic_names" {
  description = "List of topic names"
  type        = list(string)
  default     = []
}

variable "queue_names" {
  description = "List of queue names"
  type        = list(string)
  default     = []
}

# Define Azure provider
provider "azurerm" {
  features {}
}

# Create Azure resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Service Bus namespace
resource "azurerm_servicebus_namespace" "example" {
  name                = var.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

# Create Service Bus topics
resource "azurerm_servicebus_topic" "example" {
  count               = length(var.topic_names)
  name                = var.topic_names[count.index]
  namespace_name      = azurerm_servicebus_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
}

# Create Service Bus queues
resource "azurerm_servicebus_queue" "example" {
  count               = length(var.queue_names)
  name                = var.queue_names[count.index]
  namespace_name      = azurerm_servicebus_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
}
