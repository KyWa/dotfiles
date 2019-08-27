# RHV Access and Security

Root can login to cockpit/webconsole by default. To disallow change /etc/pam.d/cockpit and add a line such as

`auth requisite pam_succeed_if.so uid >= 1000 quiet_success` 

## Roles

Default roles cannot be edited, but can be copied to create specifc roles. User roles only allow access to the VM portal, admin roles allow access to admin and user portals.

### Administrator Roles (Basic)

#### SuperUser

This role gives the user full permissions across all objects and levels in your Red Hat Virtualization environment. The admin@internal user has this role. This role is for architects and engineers that create and manage the RHV environment, and for external resources that support it. For security, this role should be used sparingly after the data centers and clusters have been initially created.

#### ClusterAdmin

This role gives the user administrative permissions for all resources in a specific cluster. This role is for cluster administrators for specific clusters. Users with this role assigned to one or more clusters can administer those clusters and their resources, but cannot create new clusters.

#### DataCenterAdmin

This role gives the user administrative permissions across all objects in a specific data center, except for storage. This role is for data center administrators for specific data centers. Users with this role assigned to one or more data centers can administer all objects in a those data centers and their resources except for storage, which is manage by a StorageAdmin.

### User Roles (Basic)

#### UserRole

This role allows users to log in to the VM Portal. This role allows the user to access and use assigned virtual machines, including checking their state, and viewing virtual machine details. This role does not allow the user to administer their assigned virtual machines.

#### PowerUserRole

This role gives the user permission to manage and create virtual machines and templates at their assigned level. Users with this role assigned at a data center level can create virtual machines and templates in the data center. This role allows users to self-service their own virtual machines.

#### UserVmManager

This role allows users to manage virtual machines, and to create and use snapshots for the VMs they are assigned. If a user creates a virtual machine using the VM Portal, that user is automatically assigned this role on the new virtual machine.
