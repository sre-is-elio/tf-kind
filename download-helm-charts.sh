#!/usr/bin/env bash

declare -A CHARTS
declare -A REPOS

REPOS["metrics-server"]=https://kubernetes-sigs.github.io/metrics-server
REPOS["argo"]=https://argoproj.github.io/argo-helm
REPOS["jetstack"]=https://charts.jetstack.io
REPOS["grafana"]=https://grafana.github.io/helm-charts
REPOS["ingress-nginx"]=https://kubernetes.github.io/ingress-nginx
REPOS["prometheus-community"]=https://prometheus-community.github.io/helm-charts
REPOS["open-telemetry"]=https://open-telemetry.github.io/opentelemetry-helm-charts

for repo in "${!REPOS[@]}";
do
  helm repo add $repo ${REPOS[$repo]}
done
helm repo update

CHARTS["grafana"]=alloy
CHARTS["grafana"]=grafana
CHARTS["ingress-nginx"]=ingress-nginx
CHARTS["prometheus-community"]=kube-prometheus-stack
CHARTS["grafana"]=loki
CHARTS["metrics-server"]=metrics-server
CHARTS["grafana"]=mimir-distributed
CHARTS["grafana"]=promtail
CHARTS["grafana"]=tempo

for chart in "${!CHARTS[@]}";
do
  helm pull $chart/${CHARTS[$chart]} --untar --untardir charts
done
