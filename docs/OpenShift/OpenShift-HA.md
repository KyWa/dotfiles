# High Availability in OpenShift

### Router Subdomain and Other DNS Requirements

All hosts in the cluster need to be resolvedable using DNS. Additionaly, if using a control node as the Ansible installer, it too must be able to resolve all hosts in the cluster. 

#### DNS requirements

Typically in an HA cluster, there are two DNS names for the load-balanced IP address that points to the three master servers for access to the API, CLI, and console services. One of these names is the public name that users use to log in to the cluster. The other is an internal name that is used by internal components within the cluster to communicate with the master. These values must also resolve, and be placed in the Ansible inventory file used by the OpenShift advanced installer.

#### Public master host name

This is the hostname that external users and tools use to log into the OpenShift cluster:

* `openshift_master_cluster_public_hostname=console.cluster.example.com`

#### Internal master host name

This is the hostname that users and tools use to log into the OpenShift API and web console:

* `openshift_master_cluster_hostname=console.cluster.example.com`

#### Wildcard DNS entry for infrastructure (router) nodes

In addition to the host names for the master console and API, a wildcard DNS entry must exist under a unique subdomain, such as, `*.cloudapps.cluster.example.com`, that resolves to the IP addresses of the three infrastructures nodes via `A` records, or to their hostnames via `CNAME` records. The subdomain allows new routes to be automatically routable to the clsuter under the subdomain, such as `newapp.cloudapps.cluster.example.com`.

* `openshift_master_default_subdomain=cloudapps.cluster.example.com`
