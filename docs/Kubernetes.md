# Kubernetes and OpenShift

In OpenShift to allow storage from the host to a container/pod you must modify the SELinux configuration via: `semanage fcontext -a -t container_file_t '/path/to/data(/.*)?'`. Don't forget to apply them via `restorecon -Rv /path/to/data`.

Registries in `podman` are modified in `/etc/containers/registries.conf`.
