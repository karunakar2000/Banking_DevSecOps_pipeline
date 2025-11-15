#  infra/azure/main.tf
 # DTB – Azure infrastructure (RG, VNet, Subnet, AKS)

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Owner       = "DTB-Bank"
  }
}


# Virtual Network & Subnet

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_subnet" "aks" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

# AKS Cluster

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "system"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = var.environment
    Owner       = "DTB-Bank"
  }
}


output "aks_name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "Name of the AKS cluster"
}

output "aks_kube_config" {
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  description = "Raw kubeconfig for AKS cluster (sensitive)"
  sensitive   = true
}

output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "VNet ID"
}

output "subnet_id" {
  value       = azurerm_subnet.aks.id
  description = "AKS subnet ID"
}
