#!/usr/bin/env bash

INPUT_CLUSTER=${1:-kind-dev}
CLUSTER=${INPUT_CLUSTER/kind-/}
CUSTER_STATUS=""

echo -e "Checking KinD Cluster ${CLUSTER}..."
if [[ -z "$(kind get clusters | grep -e "${CLUSTER}")" ]];
then
  echo -e "Creating KinD Cluster ${CLUSTER}..."
  kind create cluster --name ${CLUSTER} --config resources/kind/kind.yaml
  echo -e "KinD Cluster ${CLUSTER} has been created."
  CUSTER_STATUS=$?
else
  echo -e "KinD Cluster ${CLUSTER} already has been created."
  kubectl config use-context ${INPUT_CLUSTER}
  CUSTER_STATUS=0
fi

if [[ ${CUSTER_STATUS} == 1 ]];
then
  echo "Error"
  exit -1
fi

# kubectl config view --minify --flatten --context=${INPUT_CLUSTER} -o go-template-file=tfvars.gotemplate > terraform.auto.tfvars\
#  && echo -e "\n\nSetting Terraform Workspace." && terraform workspace select -or-create local\
#  && echo -e "\n\nFormatting Terraform Code." && terraform fmt -recursive\
#  && echo -e "\n\nValidating Terraform Code." && terraform validate\
#  && echo -e "\n\nApplying Terraform Code." && terraform apply -auto-approve -input=false
