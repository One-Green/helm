test:
	helm install --debug --dry-run dry-test .

test-deploy:
	helm upgrade og-test -f values.yaml . --namespace helm-test --create-namespace --debug --install


clean-deploy-scaleway:
	helm uninstall og-test --namespace helm-test || echo "chart not installed"
	kubectl delete pvc og-test-grafana || echo "pvc already deleted"
	kubectl delete pvc og-test-influxdb-data-og-test-influxdb-0 || echo "pvc already deleted"
	kubectl delete pvc og-test-tsdb-data-og-test-tsdb-0 || echo "pvc already deleted"
	kubectl delete pvc redis-data-og-test-redis-master-0 || echo "pvc already deleted"

test-deploy-scaleway: clean-deploy-scaleway values_scaleway.yaml
	helm upgrade og-test -f values_scaleway.yaml . --namespace helm-test --create-namespace --debug --install
