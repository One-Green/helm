# One-Green Core

[One-Green](https://one-green.io/), an open source framework for plant cultivation, scalable.

Interact with IoT board provided by firmware [IoT-Edge-Agent](https://github.com/One-Green/iot-edge-agent)

This chart bootstraps a [One-Green Core](https://one-green.io/#section-core) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
- Kubernetes 1.16+
- Helm 3+

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

## MicroK8s user specification
For [Micok8s](https://microk8s.io/) enable addons  with `sudo microk8s enable dns storage helm3 ingress`, this operation can take ~15min .

Then add these lines in ~/.bashrc or ~/.zshrc

```console
alias kubectl="sudo microk8s kubectl"
alias helm="sudo microk8s helm3"
```

## Get Repo Info
```console
helm repo add one-green https://one-green.github.io/helm/charts
helm repo update
```
You can then run `helm search repo one-green` to see the charts.

## Install
```console
helm install one-green one-green/one-green-core --version 0.0.1
```

## Install on Microk8s

Microk8s use this [values_raspberry_pi_microk8s.yaml](https://github.com/One-Green/helm/blob/main/dev/values_raspberry_pi_microk8s.yaml)
```console
helm install one-green one-green/one-green-core --version 0.0.1 --values values_raspberry_pi_microk8s.yaml
```


## Get secrets

MQTT user, password
```console
# user
kubectl get secret one-green-secrets -o jsonpath='{.data.MOSQUITTO_USERNAME}' | base64 --decode
# password
kubectl get secret one-green-secrets -o jsonpath='{.data.MOSQUITTO_PASSWORD}' | base64 --decode
# token
```

Influxdb user, password, token

```console
# user
kubectl get secret one-green-secrets -o jsonpath='{.data.DOCKER_INFLUXDB_INIT_USERNAME}' | base64 --decode
# password
kubectl get secret one-green-secrets -o jsonpath='{.data.DOCKER_INFLUXDB_INIT_PASSWORD}' | base64 --decode
# token
kubectl get secret one-green-secrets -o jsonpath='{.data.DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}' | base64 --decode
```

Grafana user and password

```console
# user
kubectl get secret one-green-grafana -o jsonpath='{.data.admin-user}' | base64 --decode
# password
kubectl get secret one-green-grafana -o jsonpath='{.data.admin-password}' | base64 --decode
```
