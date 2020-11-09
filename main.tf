# Main 
# Provider, Resource Group, VNET, Subnets, Storage Account, Log Analytics Workspace

# Terraform Version Pinning
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.1.0"
    }
    bigip = {
      source = "f5networks/bigip"
      version = "~> 1.3.2"
    } 
  }
}

/* 
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.1.0"
    }
    bigip = {
      source = "f5networks/bigip"
      version = "~> 1.3.2"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 1.2.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 1.4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 2.1.2"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 2.3.0"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.1.2"
    }
  }
} */

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.sp_subscription_id
  client_id       = var.sp_client_id
  client_secret   = var.sp_client_secret
  tenant_id       = var.sp_tenant_id
}

# Get public IP
data "http" "myip" {
  url = "http://ifconfig.co"

  request_headers = {
    Accept = "text/plain"
  }
}

# Create a Resource Group if it doesn't exist
resource "azurerm_resource_group" "tfresourcegroup" {
  name     = "${var.prefix}-vlab-TF"
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "tfnetwork" {
  name                = "vnet-${var.prefix}"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.tfresourcegroup.name
}

# Create Subnets, from 
resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.tfresourcegroup.name
  virtual_network_name = azurerm_virtual_network.tfnetwork.name
  address_prefix       = each.value
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.tfresourcegroup.name
  }
  byte_length = 8
}

# Create Log Analytic Workspace
# NOTE: Log Analytics Workspace : By default this is soft-removed (Stays in the Recycle Bin for 14 days) to delete use Powershell:
# Remove-AzOperationalInsightsWorkspace -ResourceGroupName "cav-vlab-tf"  -Name "law-cav" -ForceDelete
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/7282

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law-${random_id.randomId.hex}"
  sku                 = "PerNode"
  retention_in_days   = 300
  resource_group_name = azurerm_resource_group.tfresourcegroup.name
  location            = azurerm_resource_group.tfresourcegroup.location
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.tfresourcegroup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}
