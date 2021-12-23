template: dev/values.yaml dev/values_raspberry_pi_microk8s.yaml dev/values_scaleway.yaml
	mkdir rendering || true
	helm template dev -f dev/values.yaml > rendering/values.yaml
	helm template dev -f dev/values_raspberry_pi_microk8s.yaml > rendering/values_raspberry_pi_microk8s.yaml
	helm template dev -f dev/values_scaleway.yaml > rendering/values_scaleway.yaml

test:
	helm install --debug --dry-run dry-test .

test-deploy:
	helm upgrade test-deploy -f values.yaml . --namespace helm-test --create-namespace --debug --install


clean-deploy-scaleway:
	helm uninstall og-test --namespace one-green || echo "chart not installed"
	kubectl delete pvc og-test-grafana || echo "pvc already deleted"
	kubectl delete pvc og-test-influxdb-data-og-test-influxdb-0 || echo "pvc already deleted"
	kubectl delete pvc data-og-test-postgresql-0 || echo "pvc already deleted"
	kubectl delete pvc redis-data-og-test-redis-master-0 || echo "pvc already deleted"

test-deploy-scaleway: clean-deploy-scaleway dev/values_scaleway.yaml
	helm upgrade og-test -f values_scaleway.yaml . --namespace one-green --create-namespace --debug --install

release-helm-chart: export CHART_NAME=one-green-core
release-helm-chart: export CHART_VERSION=0.0.4
release-helm-chart: export APP_VERSION=0.0.4
release-helm-chart:
	yq eval -i '.name |= "${CHART_NAME}"' dev/Chart.yaml
	yq eval -i '.version |= "${CHART_VERSION}"' dev/Chart.yaml
	yq eval -i '.version |= "${APP_VERSION}"' dev/Chart.yaml
	mkdir charts || true
	rm charts/${CHART_NAME}-${CHART_VERSION}.tgz || true
	# package + update sub-chart dependencies
	helm package dev  --debug --dependency-update --destination charts
	# update charts index.yaml
	helm repo index charts
	git add charts/${CHART_NAME}-${CHART_VERSION}.tgz
