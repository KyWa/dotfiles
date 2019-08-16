# Metrics Subsystem (Only relating for 3.9)


## OpenShift 3.11+ Uses Prometheus for Monitoring

The OpenShift metrics subsystem enables the capture and long-term storage of performance metrics for an OpenShift cluster. Metrics are collected for nodes and for all containers running in each node.

[Visual of Metrics Subsystem](https://role.rhu.redhat.com/rol-rhu/static/static_file_cache/do280-3.9/ch08/metrics-architecture.png)

The metrics sybsystem is deployed as a set of containers based on the following open source projects:

### Heapster

Collects metrics from all nodes in a Kubernetes cluster and forwards them to a storage engine for long-term storage. Red Hat OpenShift Container Platform uses Hawkular as the storage engine for Heapster. The Heapster project was incubated by the Kubernetes community to provide a way for third-party applications to capture performance data from a Kubernetes cluster.

### Hawkular Metrics

Provides a REST API for storing and querying time-series data. The Hawkular Metrics component is part of the larger Hawkular project. Hawkular Metrics uses Cassandra as its data store. Hawkular was created as the successor to the RHQ Project (the upstream to Red Hat JBoss Operations Network product) and is a key piece of the middleware management capabilities of the Red Hat CloudForms product.

### Hawkular Agent

Collects custom performance metrics from applications and forwards them to Hawkular Metrics for storage. The application provides metrics to the Hawkular Agent. The Hawkular OpenShift Agent (HOSA) is currently a technology preview features and is not installed by default Red Hat does not provide support for technology preview features and does not recommend to use them for production.

### Cassandra

Stores time-series data in a non-relational, distributed database.

The OpenShift metrics subsystem works independently of other OpenShift components. Only three parts of OpenShift require the metrics subsystem in order to provide some optional features:

    * The web console invokes the Hawkular Metrics API to fetch data to render performance graphics about pods in a project. If the metrics subsystem is not deployed, the charts are not displayed. Notice that the calls are made from the user web browser, not from the OpenShift master node.
    * The `oc adm` top command uses the Heapster API to fetch data about the current state of all pods and nodes in the cluster.
    * The `autoscaler` controller from Kubernetes invokes the Heapster API to fetch data about the current state of all pods from a deployment in order to make decisions about scaling the deployment controller.

Red Hat OpenShift Container Platform does not force an organization to deploy the full metrics subsystem. If an organization already has a monitoring system and wants to use it to manage an OpenShift cluster, there is the option of deploying only the Heapster component and to delegate long-term storage of metrics to the external monitoring system.

If the existing monitoring system provides only alerting and health capabilities, then the monitoring system can use the Hawkular API to capture metrics to generate alerts.

Heapster collects metrics for a node and its containers, then aggregates the metrics for pods, namespaces, and the entire cluster. Among the metrics that Heapster collects for a node are:

    * Working set: the memory effectively used by all processes running in the node, measured in bytes
    * CPU usage: the amount of CPU used by all processes running in the node, measured in millicores. Ten millicores is equal to one CPU busy 1% of the time.

## Accessing Heapster And Hawkular

An OpenShift user needs to understand the difference between declared resource requests (and limits) versus actual r esource usage. The declared resource requests are subtracted from the node capacity and the difference is the remaining available capacity for a node. The available capacity for a node does not reflect the actual memory and CPU in use by containers and other applications that are running inside a node.

To get a more accurate representation of usage, `oc adm top` will assist in this. Heapster is not exposed outside the cluster. To get to these metrics from external apps, the OpenShift master API proxy feature must be used. It allows access to ineral components through its own proxy. The following shows an example of accessing Heapster API using `curl`.

```sh
# Assumes MASTERURL, NODE and START env vars are defined in the user env

APIPROXY=${MASTERURL}/api/v1/proxy/namespace/openshift-infra/service
HEAPSTERAPI=https://heapster:/api/v1/model

TOKEN=$(oc whoami -t)

curl -k -H "Authorization: Bearer $TOKEN" -X GET $APIPROXY/$HEAPSTER/$NODE/metrics/memory/working_set?start=$START
```

If this system is too complicated, the upstream communities of Origin and Kubernetes also provide integration to popular open source monitoring tools such as Nagios and Zabbix.

### Sizing the Metrics Subsystem

This topic provides general information about sizing the OpenShift metrics subsystem. The Red Hat OpenShift Container Platform product documentation, specifically the Installation and Configuration document and the Scaling and Performance Guide , provide detailed information about sizing the metrics subsystem for an OpenShift cluster, based on the expected number of nodes and pods.

Each component of the OpenShift metrics subsystem is deployed using its own deployment controller and is scaled independently of the others. They can be scheduled to run anywhere in the OpenShift cluster, but system administrators will probably reserve a few nodes for the metrics subsystem pods in a production environment.

Cassandra and Hawkular are Java applications. Hawkular runs inside the JBoss EAP 7 application server. Both Hawkular and Cassandra take advantage of large heaps and the defaults are sized for a small to medium OpenShift cluster. A test environment might require changing the defaults to request less memory and CPU resources.

Heapster and Hawkular deployments are sized, scaled, and scheduled using standard OpenShift tools. A small number of Heapster and Hawkular pods can manage metrics for hundreds of OpenShift nodes and thousands of projects.

System administrators can use oc commands to configure Heapster and Hawkular deployments; for example: to increase the number of replicas or the amount of resources requested by each pod, but the recommended way to configure these parameters is by changing Ansible variables for the Metrics installation playbook. The next section, about installing the metrics subsystem, provides more information about configuring these Ansible variables.

Cassandra cannot be scaled and configured using standard oc commands, because Cassandra (as is the case for most databases) is not a stateless cloud application. Cassandra has strict storage requirements and each Cassandra pod gets a different deployment configuration. The Metrics installation playbook has to be used to scale and configure the Cassandra deployments.

### Providing Persistent Storage for Cassandra

Cassandra can be deployed as a single pod, using a single persistent volume. At least three Cassandra pods are required to achieve high availability (HA) for the metrics subsystem. Each pod requires an exclusive volume: Cassandra uses a "shared-nothing" storage architecture.

Although Cassandra can be deployed using ephemeral storage, this means there is a risk of permanent data loss. Using ephemeral storage, that is, an `emptyDir` volume type, is not recommended except for a short-lived test bed environment.

The amount of storage to use for each Cassandra volume depends not only on the expected cluster size (number of nodes and pods) but also on the resolution and duration of the time series for metrics. The Red Hat OpenShift Container Platform product documentation, specifically the Installation Guide and the Scaling and Performance Guide , provide detailed information about sizing the persistent volumes used by Cassandra for the metrics subsystem.

The Metrics installation playbook supports using either statically provisioned persistent volumes or dynamic volumes. Whatever the choice, the playbook creates persistent volume claims based on a prefix, to which a sequential number is appended. Be sure to use the same naming convention for statically provisioned persistent volumes.
