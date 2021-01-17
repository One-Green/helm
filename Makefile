test:
	helm install --debug --dry-run dry-test .

test-deploy:
	helm install one-green-test -f values.yaml . --namespace helm-test --create-namespace --debug


