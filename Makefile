kepler:
	## TODO Helm Chart for GitOps - create issue in Kepler repo
	kubectl create -f ../kepler/manifests/kubernetes/deployment.yaml

prometheus:
	kubectl apply --server-side -f ../kepler/kube-prometheus/manifests/setup
	kubectl apply -f ../kepler/kube-prometheus/manifests/
	kubectl create -f ../kepler/manifests/kubernetes/keplerExporter-serviceMonitor.yaml

grafana:
	kubectl port-forward service/grafana 3000:3000 -n monitoring && ./scripts/grafana-dashboard.sh

prometheus-helm:
	# TODO add this to ./clusters/ in config repo for GitOps
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://charts.helm.sh/stable
	helm repo update
	helm install prometheus prometheus-community/kube-prometheus-stack

prometheus-helm-linux:
	# TODO use this when running on Linux
	# curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
	# sudo apt-get install apt-transport-https --yes
	# echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	# sudo apt-get update
	# sudo apt-get install helm

# TODO verify this works
dependencies: kepler pormetheus-helm grafana
