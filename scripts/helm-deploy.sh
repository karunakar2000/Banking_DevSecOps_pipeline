#!/usr/bin/env bash
# scripts/helm-deploy.sh
# Deploys the DTB BankingOnline Helm chart to a target namespace.

set -euo pipefail

ENVIRONMENT="${1:-dev}"        # dev | uat | prod
RELEASE_NAME="${2:-banking-online}"
CHART_PATH="${3:-./helm/banking-app}"

case "$ENVIRONMENT" in
  dev)
    NAMESPACE="dev-banking"
    VALUES_FILE="k8s/overlays/dev/values-dev-placeholder.yaml"
    ;;
  uat)
    NAMESPACE="uat-banking"
    VALUES_FILE="k8s/overlays/uat/values-uat-placeholder.yaml"
    ;;
  prod)
    NAMESPACE="prod-banking"
    VALUES_FILE="k8s/overlays/prod/values-prod-placeholder.yaml"
    ;;
  *)
    echo "Unknown environment: $ENVIRONMENT (expected: dev|uat|prod)"
    exit 1
    ;;
esac

echo "Deploying DTB BankingOnline to environment: $ENVIRONMENT"
echo "Namespace: $NAMESPACE"
echo "Release:   $RELEASE_NAME"
echo "Chart:     $CHART_PATH"
echo "Values:    $VALUES_FILE"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install "$RELEASE_NAME" "$CHART_PATH" \
  --namespace "$NAMESPACE" \
  -f "$VALUES_FILE"

echo "Deployment triggered. Use 'kubectl get pods -n $NAMESPACE' to check status."
