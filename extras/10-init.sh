#!/bin/bash
#
# Bootstrap the Kubernetes cluster and AWS resources.
# See README.
#
if [ -z "$KOPS_CLUSTER_NAME" ]; then
  echo "Run the following command before running $0"
  echo '  source 01-env.sh'
  exit 1
fi

set -e
set -o pipefail
set -x
cd "$(dirname "$0")"

# Show versions
kops version
terraform version
helm version -c
helmfile -v

# Initialize kubecontext
kops export kubecfg
kops validate cluster

# Initialize Terraform
terraform init -backend-config="bucket=$state_store_bucket_name"

# Initialize Helm
helm init --client-only
