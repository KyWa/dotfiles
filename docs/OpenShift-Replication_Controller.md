# Replication Controllers

A replication controller guarantees that the specified number of replicas of a pod are running at all times. The rc instantiates more pods if pods are killed, or are deleted explicitly by an administrator. Similarly, it deletes pods as necessary to match the specified replica count, if there are more pods running than the desired count.

The defintion of a replication controller consists mainly of:

* The desired number of replicas
* A pod definition for creating a replicated pod
* A selector for identifying managed pods

The selector is a set of labels that all of the pods managed by the replication controller must match. The same set of labels must be included in the pod definition that the replicatino controller instantiates. This selector is used by the replication controller to determine how many instances of the pod are already running in order to adjust as needed. 

##### NOTE
    - The replication controller does not perform autoscaling, because it does not track load or traffic. The horizontal pod autoscaler resource manages autoscaling.

To scale an application in OpenShift it is rather simple: `oc scale --replicas=5 dc appname`. The `DeploymentConfig` resource propagates the change to the `ReplicationController`, which reacts to the change by creating new pods (replicas) or deleting existing ones.

#### Autoscaling Pods

Openshift can autoscale a deployment configuration, based on current load on the application pods, my means of a `HorizontalPodAutoscaler` resource type. A `HorizontolPodAutoscaler` (`HPA`) resource uses performance metrics collected by the OpenShift Metrics subsystem. Without the metrics subsystem, more specifically the Heapster component, autoscaling is not possible.

The recommended way to create a `HPA` resource is using the `oc autoscale` command. Example: `oc autoscale dc/appname --min 1 --max 10 --cpu-percent=80`.

This command creates a `HPA` resource that changes the number of replicas on the `appname` deployment configuration to keep its pods under 80% of their total requested CPU usage. The `HPA` is created with the name of the deployment configuration as an argument (appname in the example). A note on this, `HPA`s only work on pods that define resource requests for the reference performance metric.

Most of the pods created by the `oc new-app` command define no resource requests. Using the OpenShift autoscaler may require either creating custom YAML or JSON resource files for your application, or adding resource range resources to your project.
