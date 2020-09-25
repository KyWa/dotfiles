# OpenShift Common Items

## Operators

Operators make up the core of OpenShifts services. Operators are Kube-native applications and put all operational knowledge into "kube primitives". Adminstration tasks using shell scripts and automation software can now be run in Kube pods. They integrate natively with Kube concepts and APIs. Operators run a "reconciliation loop" to check on an application service and ensures user-specified state of objects is achieved.

Manages all deployed resources and application. Acts as application specific controllers. Extend the Kube API with CRDs.

Operator Framework:

* Operator SDK:
    * Developers build, package and test Operator
    * No knowledge of Kube API complexity required
* Operator Lifecycle Manager (OLM):
    * Helps install, update, manage the lifecycle of all Operators in the cluster
* Operator Metering:
    * Usage reporting for Operators and resources within Kubernetes

Operators can be found [here](https://operatorhub.io).

## Services

Defines a logical set of pods and access policy
    * Provides permanent internal IP address and hostname for other applications running on the cluster to use as pods are created and destroyed

The service layer connets appliation components together
    * Example: front-end web server connects to its database instance by communicating with the DBs service and not directly to its pod

Services allow simple internal load balacning across application components
    * OCP automatically injects service info into running containers for ease of discovery

## Pod Deployment

Both Deployments and DeploymentConfigs ensure the specified number of pods are running in the cluster. Each is done mostly the same, but with some slight differences in features and usability.

### Deployment

Spawns a ReplicaSet item and is a Kubernetes native object

### DeploymentConfig

Spawns a new Replication Controller for each new version. This object is unique to OpenShift
