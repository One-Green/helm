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
Then add these lines in **~/.bashrc** or **~/.zshrc**

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
helm install one-green one-green-core/one-green-core --version 0.0.1
```

## Install on Microk8s

Microk8s use this [values_raspberry_pi_microk8s.yaml](https://github.com/One-Green/helm/blob/main/dev/values_raspberry_pi_microk8s.yaml)
```console
helm install one-green one-green-core/one-green-core --version 0.0.1 --values values_raspberry_pi_microk8s.yaml
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

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminUI.enable | string | `"true"` |  admin WebUi for core rest api activation |
| adminUI.image | string | `"docker.io/shanisma/og-admin:latest"` |  admin WebUi image |
| adminUI.imagePullPolicy | string | `"Always"` | admin WebUi image pull policy  |
| adminUI.ingress.enable | string | `"true"` | admin WebUi activate ingress   |
| adminUI.ingress.host | string | `""` | admin WebUi ingress host   |
| adminUI.replicas | int | `1` | admin WebUi replicas  |
| api.image | string | `"docker.io/shanisma/og-core:latest"` | core rest api image |
| api.imagePullPolicy | string | `"Always"` | core rest api image pull strategy  |
| api.ingress.enable | string | `"false"` |  core rest api activate ingress  |
| api.ingress.host | string | `""` | core rest api ingress host |
| api.log.level | string | `"info"` | core rest api log level  |
| api.replicas | int | `1` | core rest api replicas  |
| cloudProvider | string | `"others"` | alter templates based Kubernetes provider |
| controllerWorker.HPA.cpu.targetAverageUtilization | int | `10` | async Celery Worker HPA cpu target  |
| controllerWorker.HPA.enable | string | `"true"` | async Celery Worker HPA activation  |
| controllerWorker.HPA.maxReplicas | int | `2` | async Celery Worker HPA max replicas  |
| controllerWorker.HPA.minReplicas | int | `1` | async Celery Worker HPA min replicas |
| controllerWorker.image | string | `"docker.io/shanisma/og-core:latest"` |   |
| controllerWorker.imagePullPolicy | string | `"Always"` | async Celery Worker image pull policy  |
| controllerWorker.log.level | string | `"info"` | async Celery Worker log level |
| controllerWorker.replicas | int | `1` | async Celery Worker replicas  |
| grafana.ingress.annotations | object | `{}` | refer to grafana sub chart values |
| grafana.ingress.enabled | bool | `false` |  |
| grafana.ingress.hosts[0] | string | `"chart-example.local"` |  |
| grafana.ingress.labels | object | `{}` |  |
| grafana.ingress.path | string | `"/"` |  |
| grafana.persistence.enabled | bool | `true` |  |
| grafana.persistence.size | string | `"1Gi"` |  |
| grafana.persistence.storageClassName | string | `"default"` |  |
| grafana.persistence.type | string | `"pvc"` |  |
| influxDB.dataRetention | string | `"1w"` | influxdb persist 1 week data |
| influxDB.image | string | `"influxdb:2.0.8"` | influxdb docker image |
| influxDB.persistent.enablePersistant | string | `"true"` | influxdb PVC activation |
| influxDB.persistent.storageClass | string | `"default"` | influxdb PVC storage class |
| influxDB.persistent.volumeRequest | string | `"1Gi"` | influxdb PVC volume request size |
| influxDB.secret.password | string | `"anyrandompassword"` | influxdb init admin user password |
| influxDB.secret.token | string | `"change_this_token"` |  influxdb init main token |
| influxDB.secret.user | string | `"admin"` | influxdb init admin password |
| lightController.enable | string | `"true"` | |
| lightController.image | string | `"docker.io/shanisma/og-core:latest"` | iot light mqtt sensor topic consumer image |
| lightController.imagePullPolicy | string | `"Always"` | iot light mqtt sensor topic consumer image pull policy |
| mqtt.NodePort | int | `30181` | mqtt server node port |
| mqtt.image | string | `"docker.io/shanisma/eclipse-mosquitto:1.6.12"` | mqtt server image |
| mqtt.secret.password | string | `"anyrandompassword"` | mqtt password |
| mqtt.secret.user | string | `"mqtt"` | mqtt user |
| postgresql.global.postgresql.postgresqlPassword | string | `"anyrandompassword"` | refer to postgresql sub chart values  |
| postgresql.global.postgresql.postgresqlUsername | string | `"postgres"` |  |
| postgresql.global.storageClass | string | `"default"` |  |
| postgresql.image.pullPolicy | string | `"IfNotPresent"` |  |
| postgresql.persistence.size | string | `"1Gi"` |  |
| postgresql.replication.readReplicas | int | `0` |  |
| redis.auth.enabled | bool | `false` | refer to redis sub chart values  |
| redis.auth.sentinel | bool | `false` |  |
| redis.master.persistence.size | string | `"1Gi"` |  |
| redis.master.persistence.storageClass | string | `"default"` |  |
| redis.replica.persistence.enabled | bool | `false` |  |
| redis.replica.persistence.size | string | `"1Gi"` |  |
| redis.replica.persistence.storageClass | string | `"default"` |  |
| redis.replica.replicaCount | int | `0` |  |
| sprinklerController.enable | string | `"true"` | iot sprinkler mqtt sensor topic consumer activation |
| sprinklerController.image | string | `"docker.io/shanisma/og-core:latest"` | iot sprinkler mqtt sensor topic consumer image |
| sprinklerController.imagePullPolicy | string | `"Always"` | iot sprinkler mqtt sensor topic consumer image pull policy |
| telegraf.image | string | `"telegraf:1.19.3"` | telegraf image (MQTT to Influxdb) |
| waterController.enable | string | `"true"` | iot water mqtt sensor topic consumer activation |
| waterController.image | string | `"docker.io/shanisma/og-core:latest"` | iot sprinkler mqtt sensor topic consumer image |
| waterController.imagePullPolicy | string | `"Always"` | iot sprinkler mqtt sensor topic consumer image pull policy  |

Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)


