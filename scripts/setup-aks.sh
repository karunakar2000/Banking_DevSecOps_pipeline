#!/usr/bin/env bash
# scripts/setup-aks.sh
# One-time bootstrap script for AKS + ACR used by DTB BankingOnline.

set -euo pipefail

# --------- Parameters (edit to your environment) ---------
SUBSCRIPTION_ID="${SUBSCRIPTION_ID:-<your-subscription-id>}"
LOCATION="${LOCATION:-eastus}"
RESOURCE_GROUP="${RESOURCE_GROUP:-dtb-banking-rg}"
AKS_NAME="${AKS_NAME:-dtb-aks-banking}"
ACR_NAME="${ACR_NAME:-dtbbankingacr}"  # must be globally unique
NODE_COUNT="${NODE_COUNT:-3}"
NODE_SIZE="${NODE_SIZE:-Standard_DS2_v2}"
# ---------------------------------------------------------

echo "Using subscription: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

echo "Creating resource group: $RESOURCE_GROUP"
az group create -n "$RESOURCE_GROUP" -l "$LOCATION"

echo "Creating Azure Container Registry: $ACR_NAME"
az acr create \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --sku Standard \
  --admin-enabled true

echo "Creating AKS cluster: $AKS_NAME"
az aks create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$AKS_NAME" \
  --node-count "$NODE_COUNT" \
  --node-vm-size "$NODE_SIZE" \
  --network-plugin azure \
  --generate-ssh-keys

echo "Attaching ACR to AKS"
az aks update \
  --resource-group "$RESOURCE_GROUP" \
  --name "$AKS_NAME" \
  --attach-acr "$ACR_NAME"

echo "Getting kubeconfig"
az aks get-credentials \
  --resource-group "$RESOURCE_GROUP" \
  --name "$AKS_NAME" \
  --overwrite-existing

echo "AKS setup complete. Current context:"
kubectl config current-context
kubectl get nodes
