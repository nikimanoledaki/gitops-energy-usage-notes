#!/bin/bash
minikube start --container-runtime=containerd --memory=6g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0
minikube addons disable metrics-server
flux bootstrap github --owner=nikimanoledaki --repository=gitops-energy-usage --path=clusters

kubectl wait --for=condition=Ready=true pods -l app.kubernetes.io/name=grafana

curl -fsSL "https://raw.githubusercontent.com/nikimanoledaki/gitops-energy-usage/main/scripts/grafana-kepler-dashboard.json" -o grafana-kepler-dashboard.json

kubectl port-forward service/grafana 3000:3000 -n monitoring

grafana_host="http://localhost:3000"
grafana_cred="admin:admin"
grafana_datasource="kepler"
  echo -n "Processing: "
  j=$(cat grafana-kepler-dashboard.json)
  curl -s -k -u "$grafana_cred" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{\"dashboard\":$j,\"overwrite\":true, \
        \"inputs\":[{\"name\":\"KEPLER\",\"type\":\"datasource\", \
        \"pluginId\":\"kepler\",\"value\":\"$grafana_datasource\"}]}" \
    $grafana_host/api/dashboards/import; echo ""
