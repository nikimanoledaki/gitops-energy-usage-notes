#!/bin/bash
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
