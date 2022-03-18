terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
    name = "${var.prefix}-${var.env}-RG"
    location = "eastus"
    tags = {
        Name = "${var.prefix}-${var.env}-RG"
        Environment = var.env
        CostCenter = "IT"
    }
}


