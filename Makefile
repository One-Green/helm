template: dev/values.yaml
	mkdir rendering || true
	helm template dev -f dev/values.yaml > rendering/values.yaml

test:
	helm install --debug --dry-run dry-test dev

test-deploy:
	helm dependencies update dev
	helm upgrade test-deploy -f dev/values.yaml dev --namespace helm-test --create-namespace --debug --install


clean-deploy-scaleway:
	helm uninstall og-test --namespace one-green || echo "chart not installed"
	kubectl delete pvc og-test-grafana || echo "pvc already deleted"
	kubectl delete pvc og-test-influxdb-data-og-test-influxdb-0 || echo "pvc already deleted"
	kubectl delete pvc data-og-test-postgresql-0 || echo "pvc already deleted"
	kubectl delete pvc redis-data-og-test-redis-master-0 || echo "pvc already deleted"

test-deploy-scaleway: clean-deploy-scaleway dev/values_scaleway.yaml
	helm upgrade og-test -f values_scaleway.yaml . --namespace one-green --create-namespace --debug --install


release:
	helm package dev  --debug --dependency-update --destination charts
	helm repo index charts
