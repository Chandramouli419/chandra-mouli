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

variable "topic_name" {
  description = "Name of the Service Bus topic"
  type        = string
}

variable "queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
}

# Define Azure provider
provider "azurerm" {
  features {}
}

# Create Azure Service Bus namespace
resource "azurerm_servicebus_namespace" "example" {
  name                = var.servicebus_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

# Create a Service Bus topic
resource "azurerm_servicebus_topic" "example" {
  name                = var.topic_name
  namespace_name      = azurerm_servicebus_namespace.example.name
  resource_group_name = var.resource_group_name
}

# Create a Service Bus queue
resource "azurerm_servicebus_queue" "example" {
  name                = var.queue_name
  namespace_name      = azurerm_servicebus_namespace.example.name
  resource_group_name = var.resource_group_name
}
