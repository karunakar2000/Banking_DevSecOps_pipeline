# infra/azure/variables.tf

variable "location" {
  description = "Azure location for DTB Bank infrastructure"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group for AKS and networking"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR range for the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the AKS subnet"
  type        = string
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for AKS API server"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in AKS default node pool"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "environment" {
  description = "Environment name (dev / uat / prod)"
  type        = string
}
