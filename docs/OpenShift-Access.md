# Controlling Access to OpenShift Resources

Cluster Admins can create projects and delegate rights for the project to any user. Examples of how to assign roles:

*Restricting project creation* - Removing the `self-provisioner cluster role from the authenticated users/groups denies permission for self-provisioning any new projects

`oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated system:authenticated:oauth`

*Granting project creation* - Project creation is granted to users with the `self-provisioner` role and the `self-provisioner` cluster role binding. This is enabled by default for all authenticated users

`oc adm policy add-cluster-role-to-group self-provisioner system:authenticated system:authenticated:oath`

You can view the details about a role by using `oc describe`. Examples:

* `oc describe clusterPolicyBindings :default` - Views Cluster bindings
* `oc describe policyBindings :default` - Views Local bindings

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

### Security Context Contraints

`SCC` can control the actions that a pod can perform and what resources it can get. By default, the execution of any container will be granted only the capabilites defined by the restricted SCC.

`oc get scc` - This will list all available `SCC`s.
`oc describe scc scc_name` - This will give a description of a specific `SCC`

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

