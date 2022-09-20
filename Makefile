grafana:
	kubectl port-forward service/grafana 3000:3000 -n monitoring && ./scripts/grafana-dashboard.sh

