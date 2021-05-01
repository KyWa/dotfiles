# OpenShift Authentication and Authorization

## Components

Core namespaces for access are `openshift-authentication-operator` and `openshift-authentication`. The `openshift-authentication` namespace contains pods which logs can be viewed for auth related issues. The authentication-operator should also be checked for logs if issues arise with authentication

When a cluster is created a user `system:admin` is created and its credntials can be found in the install dir on the machine that ran the install. These credentials should be kept as a "breakglass" measure and stored securely.

By default the kubeadmin user exists and can be used to access the cluster. To disable this account simple delete its secret in the `kube-system` namespace. Even if the secret is recreated access will not be restored. Please note you should verify you have another account to access the cluster prior to doing this.

Groups treat users as strings. No validation occurs to check if users are valid and exist.

## Authentication

### HTPasswd

HTPasswd identities are stored in a secret in the `openshift-config` namespace. To add HTPasswd authentication to the cluster there are a few easy steps to accomplish this. 

1. Create an HTPasswd file locally: `touch htpasswd`
2. Add Users to the `htpasswd` file: `htpasswd -Bb htpasswd USER PASSWORD`
3. Create secret in the cluster: `oc create secret generic htpasswd --from-file=htpasswd -n openshift-config`

To update passwords or add users to the existing HTPasswd secret its a similar method

1. Dump the secret out to a file: `oc get secret htpasswd -n openshift-config -o jsonpath={.data.htpasswd} | base64 -d > htpasswd`
2. Update the contents as with adding: `htpasswd -Bb htpasswd USER PASSWORD`
3. Patch the secret with the changes: `oc patch secret htpasswd -p '{"data":{"htpasswd":"'$(base64 -w0 htpasswd)'"}}'`

### LDAP

LDAP Authentication is called "binding". LDAP "bind" actions authenticates to an LDAP server with user identity (DN) and password. LDAP authentication requires both LDAP search for user and bind to check user password. Separate accounts often required to initially bind to LDAP to perform first user search. If the LDAP server requires binding for search, bind passwords must be provided as a secret. To create the bind secret the steps below can be followed:

```
oc create secret generic ldap-bind-password -n openshift-config --from-literal=bindPassword=PASSWORD
```

LDAP TLS Security requires TLS CA Certificate. The LDAP identity provider defaults to TLS regardless if using `ldap://` or `ldaps://`. The CA for LDAP TLS is stored in the `openshift-config` namespace as a `configMap`. The configMap can be created by the following:

```
oc create configmap ldap-tls-ca -n openshift-config --from-file=ca.crt=PATH_TO_LDAP_CA_FILE
```

Example Oauth Config for LDAP Identity Provider

```yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: OpenTLC LDAP
    challenge: true
    login: true
    mappingMethod: claim
    type: LDAP
    ldap:
      attributes:
        id: ["dn"]
        email: ["mail"]
        name: ["cn"]
        preferredUsername: ["uid"]
      bindDN: "uid=admin,cn=users,cn=accounts,dc=shared,dc=example,dc=com"
      bindPassword:
        name: ldap-bind-password
      insecure: false
      ca:
        name: ldap-tls-ca
      url: "ldaps://ipa.example.com:636/cn=users,cn=accounts,dc=shared,dc=example,dc=com?uid?sub?(memberOf=cn=ocp-users,cn=groups,cn=accounts,dc=shared,dc=example,dc=com)"
```

## Authorization

### RBAC

RBAC objects determine whether a user is allowed to perform specific action with regard to a specific type of resource. OpenShift RBAC controls access to resources and denies by default. If its not defined, its denied.

* Roles: Scoped to project namespaces, map allowed actions (verbs) to resource types in namespace
* ClusterRoles: Cluster-wide, map allowed actions (verbs) to cluster-scoped resource types or resource types in any project namespace
* RoleBindings: Grant access by associating Roles or ClusterRoles to users or groups for access within project namespace
* ClusterRoleBindings: Grant access by associating ClusterRoles to users or groups for access to cluster-scoped resources or resources in any project/namespace

Roles, ClusterRoles are a collection of rules
Rules are a list of verbs permitted on listed subjects. Rule subjects are generally resources accessed through API groups. List of available resources and api-groups can be found with `oc api-resources`. Rule subject may be constrained to specific resource names.

Built in Cluster Roles

| Name             | Description                                                                                                   |
| ---              | ---                                                                                                           |
| admin            | Project Administrator. Can manage most resource types in project.                                             |
| basic-user       | Can get basic info about users and projects                                                                   |
| cluster-admin    | Can perform any action on any resource type. Not intended for rolebindings on namespaces                      |
| edit             | Can modify most objects in project. Ability to use `oc exec/rsh` commands                                     |
| self-provisioner | Can create own projects and becomes admin of those projects                                                   |
| sudoer           | Can impersonate `system:admin user for full access                                                            |
| view             | Can view most objects in a project. Cannot make any modifications. Cannot view roles, rolebindings or secrets |

Granting access to these RBAC objects can be done via `oc policy`. Removal of access is similar. Examples below:

```bash
oc policy add-role-to-user CLUSTER_ROLE/ROLE USER -n NAMESPACE
oc adm policy add-cluster-role-to-user CLUSTER_ROLE/ROLE USER

oc policy add-role-to-group CLUSTER_ROLE/ROLE GROUP -n NAMESPACE
oc adm policy add-cluster-role-to-group CLUSTER_ROLE/ROLE GROUP

oc policy remove-role-from-user CLUSTER_ROLE/ROLE USER -n NAMESPACE
oc adm policy remove-cluster-role-from-user CLUSTER_ROLE/ROLE USER

oc policy remove-role-from-group CLUSTER_ROLE/ROLE GROUP -n NAMESPACE
oc adm policy remove-cluster-role-from-group CLUSTER_ROLE/ROLE GROUP
```

To remove ALL bindings for a user in a namespace: `oc policy remove-user USER -n NAMESPACE`

    # NOTE
    Role bindings may be created for non-existent users and groups. A warning appears only if the user creating the binding has access to list users and groups.
    
To remove the ability for self-provisionment it takes 2 items:

```bash
oc annotate clusterrolebinding self-provisioners rbac.authorization.kubernetes.io/autoupdate=false --overwrite

oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
```

A role and binding can be created to access CRDs/apiGroups in the cluster, but the rolebinding must target `namespace` or the binding will default to looking at `clusterrole` instead of `role`. Note: You can only use ServiceAccounts or Users in the subsequent fields for the bindings

## Pod Security

### ServiceAccounts

Bindings are managed similarly for SerivceAccounts (`oc policy -z SERVICEACCOUNT`).

### SCC

If multiple SCCs are applied priorty is applied. Roles can add SCCs as a use verb.

You can impersonate a serviceaccount for troubleshooting via: `oc --as-system:serviceaccount:NAMESPACE:SA`

    # NOTE
    If migrating from an OCP 3 cluster to OCP4 via CAM tool SCCs are not copied over
