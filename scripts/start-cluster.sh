#!/bin/bash
# minikube start --container-runtime=containerd --memory=6g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0
# minikube addons disable metrics-server
#!/bin/bash

# Install docker
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER
newgrp docker
docker version
sudo systemctl status docker

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Start a kind cluster
kind create cluster

# Bootstrap Flux
flux bootstrap github --owner=nikimanoledaki --repository=gitops-energy-usage --path=clusters

while : ; do
  kubectl get pod -l app.kubernetes.io/name=grafana && break
  sleep 5
done

# Configure Grafana
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
