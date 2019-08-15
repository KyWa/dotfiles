# Replication Controllers

A replication controller guarantees that the specified number of replicas of a pod are running at all times. The rc instantiates more pods if pods are killed, or are deleted explicitly by an administrator. Similarly, it deletes pods as necessary to match the specified replica count, if there are more pods running than the desired count.

The defintion of a replication controller consists mainly of:

* The desired number of replicas
* A pod definition for creating a replicated pod
* A selector for identifying managed pods

The selector is a set of labels that all of the pods managed by the replication controller must match. The same set of labels must be included in the pod definition that the replicatino controller instantiates. This selector is used by the replication controller to determine how many instances of the pod are already running in order to adjust as needed. 

##### NOTE
    - The replication controller does not perform autoscaling, because it does not track load or traffic. The horizontal pod autoscaler resource manages autoscaling.


