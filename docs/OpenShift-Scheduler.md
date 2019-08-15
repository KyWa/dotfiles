# OpenShift Scheduler

The OpenShift pod scheduler algorithm follows a three-step process:

1. Filtering nodes.
    * The scheduler filters the list of running nodes by the availability of node resources, such as host ports. Filtering continues considering node selectors and resource requests from the pod. The end result is a shorter list of candidates to run the pod.
    * A pod can define a node selector that match the labels in the cluster nodes. Nodes whose labels do not match are not eligible.
    * A pod can also define resource requests for compute resources such as CPU, memory, and storage. Nodes that have insufficient free computer resources are not eligible.
2. Prioritizing the filtered list of nodes.
    * The list of candidate nodes is evaluated using multiple priority criteria, which add up to a weighted score. NOdes with higher values are better candidates to run the pod.
    * Among the criteria are `affinity` and `anti-affinity` rules. Nodes with higher affinity for the pod have a higher score and nodes with higher anti-affinity have a lower score.
    * A common use for `affinity` rules is to schedule related pods to be close to each other, for performance reasons. An example is to use the same network backbone for pods that need to stay synchronized with each other.
    * A common use for `anti-affinity` rules is to schedule related pods not too close to each other, for high availability. One example is to avoid scheduling all pods from the same application to the same node.
3. Selecting the best fit node.
    * The candidate list is sorted based on the scores and the node with the highest score is selected to host the pod. If multiple nodes have the same high score, then one is selected at random.

The scheduler configuration file at `/etc/origin/master/scheduler.json` defines a set of predicates that are used as either filter or priority functions. This was the scheduler can be configured to support different clsuter topoligies.

#### Scheduling and Topology

A common topology for large data centers, such as cloud providers, is to organize hsots into `regions` and `zones`:

* A `region` is a set of hosts in a close geographic area, which guarantees high-speed connectivity between them.
* A `zone`, also called an `availabilty zone` (in AWS), is a set of hosts that might fail together because they share common critical infrastructure components, such as network, storage or power.

The standard configuration of the OpenShift pod scheduler supports this kind of cluster topology by defining predicates based on the `region` or `zone` labels. The predicates are defined in such a way that:

* Replica pods, created from the same replication controller, or from the same deployment config, are scheduled to run in nodes having the same value for the `region` label.
* Replica pods are scheduled to run in nodes havign different values for the `zone` label.

[Multi-Region Multi-Zone Example](https://role.rhu.redhat.com/rol-rhu/static/static_file_cache/do280-3.9/ch07/regions-and-zones.png)

Command to label a node as such: `oc label node1.cluster.example.com region=us-west zone=power1a --overwrite`. Notice that changes to the `region` label require the `--overwrite` option. This is because RHOCP Advanced Installation method configures nodes with the `region=infra` by default. You can view node labels with `oc get node nodename --show-labels`.

##### IMPORTANT
    - Each node must be identified by its FQDN when labeling region/zones

### Unschedulable Nodes

To mark a node as unschedulable, use this command: `oc adm manage-node --schedulable=false node.cluster.example.com`. Then Drain the node via `oc adm drain node.cluster.example.com`. This will destroy all pods running in the node and assumes these pods will be recreated in the remaining available nodes by a deployment configuration. Once maintenance is complete, to bring the node back in run: `oc adm manage-node --schedulable=true node.cluster.example.com`.


### Controlling Pod Placement

Some applications might require unning on a specifc set of nodes. Certain nodes may provide hardware acceleration for certain types of workloads or the cluster admin does not want to mix production applicatinos with development applications. Node labels and node selectors are used to implement these kind of scenarios.

A node selector is part of a pod definition, but it is recommended to change the deployment configuration and not the pod definition. To add a node selector, change the pod definition using either the `oc edit` or the `oc patch` commands. For example, to configure the `myapp` deployment configuration so that its pods only run on nodes that have the `env=qa` label, use the following command: `oc patch dc myapp --patch '{"spec":{"template":{"nodeSelector":{"env":"qa"}}}}'`. This will trigger a new deployment and the new pods are scheduled according to the node selector.
