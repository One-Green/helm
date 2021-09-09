Helm deployment for One-green master stack
==========================================

Quick start with MicroK8s and Raspberry Pi 4

``` {.sourceCode .shell}
# can take ~15-20 minutes
sudo microk8s enable dns dashboard storage helm3 ingress

# clone this project first
git clone https://github.com/One-Green/helm.git && cd helm
sudo microk8s helm3 dependency update
sudo microk8s helm3 install one-green-core . -n default -f values_raspberry_pi_microk8s.yaml

# Check if all pods are up and running
sudo microk8s kubectl get po -n default -w

# if you see something like that, it's ok
NAME                                     READY   STATUS    RESTARTS   AGE
one-green-core-influxdb-0                1/1     Running   1          22h
one-green-core-tsdb-0                    1/1     Running   0          151m
one-green-core-telegraf-0                1/1     Running   2          22h
one-green-core-api-756dfd65d7-gscxc      1/1     Running   1          22h
one-green-core-mqtt-0                    1/1     Running   0          133m
one-green-core-sprinklers-controller-0   1/1     Running   0          131m
one-green-core-grafana-f6fc8d87f-zjn2l   1/1     Running   0          14m
one-green-core-water-controller-0        1/1     Running   2          130m

# use CTL+C to quit watch pod
```

Goto Grafana dashboard
======================

Get Grafana **admin** password:

``` {.sourceCode .shell}
sudo microk8s kubectl get secret --namespace default one-green-core-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
# will output something like that, this is grafana admin password for this testing deployment
TzuiPvLIQdtrPUdVRcvWe0OvKote3zDz1J3MCAMY
```

Open your web browser like:

> -   url : <http://>\<raspberry\_pi\_local\_ip\>/one-green-core-grafana
> -   user : **admin**
> -   password: use mentioned command

Connect InfluxDb to Grafana
===========================

Go to
<http://>\<raspberry\_pi\_local\_ip\>/one-green-core-grafana/datasources/new

Select InfluxDb

Configure like :

> -   Section "HTTP"
>     :   URL: <http://one-green-core-influxdb:8086>
>
> -   Section "InfluxDB Details"
>     :   Database: one\_green
>
>         User: admin
>
>         Password: anyrandompassword
>
Click on "Save and Test"

IoT devices: MQTT server
========================

On IoT devices, use these configuration to connect to MQTT broker:

> -   host: \<raspberry\_pi\_local\_ip\>
> -   port: 30181
> -   user: mqtt
> -   password: anyrandompassword

