# Controlling Access to OpenShift Resources

### Creating Users

`oc create user username`. Depending on your identity provider depends on how you edit/manage the account password. For `HTPasswdIdentityProvider` in a basic install, you will login to the master node and issue a `htpasswd` command.

### Cluster Information

Cluster Admins can create projects and delegate rights for the project to any user. Examples of how to assign roles:

*Restricting project creation* - Removing the `self-provisioner cluster role from the authenticated users/groups denies permission for self-provisioning any new projects

`oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated system:authenticated:oauth`

*Granting project creation* - Project creation is granted to users with the `self-provisioner` role and the `self-provisioner` cluster role binding. This is enabled by default for all authenticated users

`oc adm policy add-cluster-role-to-group self-provisioner system:authenticated system:authenticated:oath`

You can view the details about a role by using `oc describe`. Examples:

* `oc describe clusterPolicyBindings :default` - Views Cluster bindings
* `oc describe policyBindings :default` - Views Local bindings

Local Policy is reference to Project-level access. Cluster Policy is reference to overall administrative access.

*A quick table showing some of the operations for managing local policies*

| Command                                                 | Description                                                |
| ---                                                     | ---                                                        |
| oc adm policy who-can `verb` `resource`                 | Indicates which users can perform an action on a resource. |
| oc adm policy add-role-to-user `role` `username`        | Binds a given role to specified users.                     |
| oc adm policy remove-role-from-user `role` `username`   | Removes a given role from specified users.                 |
| oc adm policy remove-user `username`                    | Removes specified users and all of their roles.            |
| oc adm policy add-role-to-group `role` `groupname`      | Binds a given role to specified groups.                    |
| oc adm policy remove-role-from-group `role` `groupname` | Removes a given role from specified groups.                |
| oc adm policy remove-group `groupname`                  | Removes specified groups and all of their roles.           |

*Table for operations of cluster policies*

| Command                                                         | Description                                                                 |
| ---                                                             | ---                                                                         |
| oc adm policy add-cluster-role-to-user `role` `username `       | Binds a given role to specified users for all projects in the cluster.      |
| oc adm policy remove-cluster-role-from-user `role` `username`   | Removes a given role from specified users for all projects in the cluster.  |
| oc adm policy add-cluster-role-to-group `role` `groupname`      | Binds a given role to specified groups for all projects in the cluster.     |
| oc adm policy remove-cluster-role-from-group `role` `groupname` | Removes a given role from specified groups for all projects in the cluster. |

### User Types

All interaction with OpenShift is associated with a user. 

* `Regular users` - This is the way the most interactive OCP users are represented. Represented by the `user` object
* `System users` - Many of these are created automatically when the infrastructure is defined, mainly for the purpose of enabling the infrastructure to securely interact with the API. System users include a cluster admin (full access), a per-node user, users for use by routers and registires and others. An anonymous system user also exists that is used by default for unauthenticated request. Examples of system users include: `system:admin`, `system:openshift-registry`, and `system:node:node1.example.com`.
* `Service accounts` - These are special system users associated with projects; some are created automatically when the project is first created, and project administrators can create more for the purpose of defining access to the contents of each project. Service accounts are represented with the `ServiceAccount` object. Examples of service account users include `system:serviceacount:default:deployer` and `system:serviceaccount:foo:builder`.

Every user must authenicate before they can access OCP. API requets with *no authentication or invalid authentication* are authenticated as requests by the anonymous system user. After successful authentication, policy determines what the user is authorized to do.

### Security Context Contraints (SCC)

`SCC` can control the actions that a pod can perform and what resources it can get. By default, the execution of any container will be granted only the capabilites defined by the restricted SCC.

`SCC` limits the access from a running pod in OpenShift to the host enviornment. SCC controls:

* Running privileged containers
* Requesting extra capabilities to a container
* Using host directories as volumes
* Changing the SELinux context of a container
* Changing the user ID

`oc get scc` - This will list all available `SCC`s.
`oc describe scc scc_name` - This will give a description of a specific `SCC`

OpenShift has seven SCCs:

* `anyuid`
* `hostaccess`
* `hostmount-anyuid`
* `nonroot`
* `privileged`
* `restricted`

### Service Accounts

Service accounts provide a flexible way to control API access without sharing a regular users credentials. `oc create serviceaccount accountname` will create a service account. This can have policies applied to it just as any other user could.

### Roles

| Default Role     | Description                                                                                                                                                                                           |
| ---              | ---                                                                                                                                                                                                   |
| admin            | A project manager. If used in a local binding, an admin user will have rights to view any resource in the project and modify any resource in the project except for role creation and quota.          |
| basic-user       | A user that can get basic information about projects and users.                                                                                                                                       |
| cluster-admin    | A super-user that can perform any action in any project. When granted to a user within a local policy, they have full control over quota and roles and every action on every resource in the project. |
| cluster-status   | A user that can get basic cluster status information.                                                                                                                                                 |
| edit             | A user that can modify most objects in a project, but does not have the power to view or modify roles or bindings.                                                                                    |
| self-provisioner | A user that can create their own projects.                                                                                                                                                            |
| view             | A user who cannot make any modifications, but can see most objects in a project. They cannot view or modify roles or bindings.                                                                        |

### SELinux

OpenShift requires SELinux to be enabled on each host to provide safe access to resources using mandatory access control. Docker containers managed by OpenShift need to manage SELinux contexts to avoid compatability problems. To minimize the risk of containers running without SELinux support, the SELinux context strategy can be created.

In order to update the SELinux context, a new SCC can be generated by using an existing SCC as a starting point:

`oc export scc restricted > custom_selinux.yml`

*The above will create something similar to this:*
```yaml
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegedContainer: false
allowedCapabilities: null
apiVersion: v1
defaultAddCapabilities: null
fsGroup:
  type: MustRunAs
groups:
- system:authenticated
kind: SecurityContextConstraints
metadata:
  annotations:
    kubernetes.io/description: restricted denies access to all host features and requires
      pods to be run with a UID, and SELinux context that are allocated to the namespace.  This
      is the most restrictive SCC.
  creationTimestamp: null
  name: restricted
priority: null
readOnlyRootFilesystem: false
requiredDropCapabilities:
- KILL
- MKNOD
- SYS_CHROOT
- SETUID
- SETGID
runAsUser:
  type: MustRunAsRange
seLinuxContext: 
  type: MustRunAs # <--- Edit this to RunAsAny
supplementalGroups:
  type: RunAsAny
volumes:
- configMap
- downwardAPI
- emptyDir
- persistentVolumeClaim
- secret
```

Then just run `oc create` on that file and your set.