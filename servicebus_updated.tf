provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "example-eventhub-namespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 1
}

variable "eventhub_configs" {
  type = list(object({
    name               = string
    partition_count    = number
    message_retention  = string
    consumer_group_names = list(string)
  }))
  default = [
    {
      name              = "eventhub1"
      partition_count   = 2
      message_retention = "1"
      consumer_group_names = ["consumer1", "consumer2"]
    },
    {
      name              = "eventhub2"
      partition_count   = 4
      message_retention = "2"
      consumer_group_names = ["consumer3", "consumer4"]
    }
  ]
}

resource "azurerm_eventhub" "example" {
  for_each             = { for config in var.eventhub_configs : config.name => config }
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.example.name
  namespace_name       = azurerm_eventhub_namespace.example.name
  partition_count      = each.value.partition_count
  message_retention    = each.value.message_retention
}

resource "azurerm_eventhub_consumer_group" "example" {
  for_each             = flatten([for config in var.eventhub_configs : [for consumer_group in config.consumer_group_names : "${config.name}-${consumer_group}"]])
  name                 = each.value
  resource_group_name  = azurerm_resource_group.example.name
  namespace_name       = azurerm_eventhub_namespace.example.name
  eventhub_name        = azurerm_eventhub.example[split("-", each.value)[0]].name
}
