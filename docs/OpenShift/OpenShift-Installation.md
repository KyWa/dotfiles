# OpenShift Installation

[Post Installation](OpenShift-Post-Installation)

## Via Ansible

*Repos to enable Ansible on RHEL7*

`subscription-manager repos --enable="rhel-7-server-ansible-2.4-rpms`

`yum install ansible openshift-ansible`

Via the openshift-ansible installers you have a few inventory groups to add:

* `masters` - This group is mandatory and defines which hosts act as master hosts in the OpenShift cluster.
* `nodes` - This group is mandatory and defines which hosts act as node hosts in the OpenShift cluster. All hosts listed in the [masters] section should also be included in this section.
* `etcd` - The group of hosts that run the etcd service for the OpenShift cluster.
* `nfs` - This group is optional and should only contain one host. If particular variables are present in the inventory file, the OpenShift playbooks install and configure NFS on this machine.
* `OSEv3` - This group contains any machine that is a part of the OpenShift cluster. The installation playbooks reference this group to run cluster-wide tasks.

Inventory file needs to have vars set for the `OSEv3` section. Some of the vars available are used to configure things such as: registry, storage, metrics, logging, certs etc... One important variable to note is the `openshift_deployment_type` which has 2 options: `openshift-enterprise` and `origin`. `openshift-release` is a var to specify which version of RHOCP to install. 

### Configuring Authentication

OpenShift auth is based on `OAuth` which handles the HTTP-based API for auth on both interactive and noninteractive clients. The OpenShift master runs an OAuth server and OpenShift can be configured with a number of identity providers. OpenShift supports the following identity providers: HTTP Basic, Github and Gitlab, OpenID Connect (for OpenID-compatible SSO and Google Accounts), OpenStack Keystone v3, and LDAP v3. By default the installer sets `DenyAllPasswordIdentityProvider` as the default provider. Because of this, only the local `root` user on a master machine can use OpenSfhit client commands and APIs.

OpenShift `HTPasswdPasswordIdentityProvider` validates users and passwords against a flat file generated with the Apache HTTPD htpasswd utility. This isn't meant to be used to enterprise-grade identity management, but works for POC deployments. To enable `htpasswd` authentication add this block to the variable in the Ansible inventory:

```
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true',
'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 
'filename': '/etc/origin/master/htpasswd'}]
```

`htpasswd` command will generate hased passwords:

* `htpasswd -nb user password` - will hand out something like: admin:$apr1$.NHMsZYc$MdmfWN5DM3q280/W7c51c/

You can add OpenShift users to the inventory vars like so:

```
openshift_master_htpasswd_users="{'user1':'$apr1$.NHMsZYc$MdmfWN5DM3q280/W7c51c/', 'user2':'$apr1$.NHMsZYc$MdmfWN5DM3q280/W7c51c/'}"
```

You can also use `openssl` to generate a salted hash`:

* `openssl passwd -apr1 password` - will generate something like: $apr1$A05Inu1A$IXdpq6d/m7mxondHEy6zC1

### Configuring Persistent Storage

OpenShift storage can use a number of storage platforms: NFS, iSCSI, GlusterFS, Ceph, and other commercial cloud storages. For the OpenShift Container Registry, add these vars to the inventory file:

```
openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_nfs_directory=/exports
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_nfs_options='*(rw,root_squash)'
openshift_hosted_registry_storage_volume_size=40Gi
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
```

The OpenShift Ansible Broker is a containerized Service that deploys its own `etcd` service. The inventory file needs vars for this as well and are similar to the Registry:

```
openshift_hosted_etcd_storage_kind=nfs
openshift_hosted_etcd_storage_nfs_directory=/exports
openshift_hosted_etcd_storage_volume_name=etcd-vol2
openshift_hosted_etcd_storage_nfs_options="*(rw,root_squash,sync,no_wdelay)"
openshift_hosted_etcd_storage_volume_size=1G
openshift_hosted_etcd_storage_access_modes=["ReadWriteOnce"]
openshift_hosted_etcd_storage_labels={'storage': 'etcd'}
```

### Configuring a Disconnected OpenShift Cluster

When installing OpenShift offline, the needed RPMs and container images must be available from the environment. A custom set of variables are needed in the inventory file for this. Example variables below:

```
# Modifications Needed for a Disconnected Install
oreg_url=registry.lab.example.com/openshift3/ose-${component}:${version}
openshift_examples_modify_imagestreams=true
openshift_docker_additional_registries=registry.lab.example.com
openshift_docker_blocked_registries=registry.access.redhat.com,docker.io

# Image Prefix Modifications
openshift_web_console_prefix=registry.lab.example.com/openshift3/ose-
openshift_cockpit_deployer_prefix='registry.lab.example.com/openshift3/'
openshift_service_catalog_image_prefix=registry.lab.example.com/openshift3/ose-
template_service_broker_prefix=registry.lab.example.com/openshift3/ose-
ansible_service_broker_image_prefix=registry.lab.example.com/openshift3/ose-
ansible_service_broker_etcd_image_prefix=registry.lab.example.com/rhel7/
```

### Configuring Node Labels

Node labels are arbitrary key/value pairs of metadata that are assigned to each node. Often used to differentiate geographic data centers or identify available resources on a node. Applications can declare in their deployment configuration a node selector in the form of a node label. Node Labels are set in the inventory file using host variables:

```
[nodes]
nodeX.example.com openshift_node_labels="{'zone':'west', 'gpu':'true'}"
```

Nodes in the `[masters]` block of the inventory get flagged with a `node-role.kubernetes.io/master=true` node label. The node selector for application pods is `node-role.kubernetes.io/compute=true`. Any node that hosts infrastructure pods must have a node label of `region=infra`. If a node is designed to host both infra and application pods, both node labels must be explicitly defined:

```
[nodes]
nodeX.example.com  openshift_node_labels="{'region':'infra', 'node-role.kubernetes.io/compute':'true'}"
```

### Executing the OpenShift Playbooks (ONLY RELEVANT FOR 3.11. 4.0+ has changed)

2 Playbooks make up the `openshift-ansible` setup. `prerequisites.yml` and `deploy_cluster.yml`. The initial one `prereq` just verifies everything is in place and ready to go prior to actual installation. The other `deploy_cluster` actually does the pulling of RPMs and cert management etc.

### Verifying the Installation

If `deploy_cluster.yml` completes with no errors, the GUI will be available (if running one master) at the URL of the master node: `https://<FQDN of the master>:port`. The port is the value of the `openshift_master_console_port` variable.
